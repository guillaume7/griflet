module class_paises

  use class_colecao

  implicit none

  integer, parameter  :: StringLength = 128

  type, extends(C_Colecao) :: C_Paises

    character(len=StringLength) :: nome

    character(len=StringLength) :: capital

    real                        :: pop

    real                        :: pib

  contains

    !Constructor

    procedure :: fundar     => fundar_pais

    !Sets

    !Gets

    !C_Paises methods

    procedure  adicionar  => adicionar_pais

    procedure  explorar   => explorar_pais
    
    procedure  mostrar    => mostrar_paises

    !Destructor

  end type C_Paises

contains

  !Constructor
  
  subroutine fundar_pais(self)

    class(C_Paises) :: self
    
    if ( .not. self.temPrimeiro() ) then
    
      call self.iniciar(1)
    
    end if
                
    write(*,*) 'Descoberta dum novo Mundo:'

    write(*,*) ''

    write(*,*) 'Insira o nome do pais'
    
    read(*,*) self%nome

    write(*,*) 'Insira a sua capital'
    
    read(*,*) self%capital

    write(*,*) 'Insira a populacao em milhoes de habitantes'
    
    read(*,*) self%pop

    write(*,*) 'Insira o PIB em milhoes de euros'
    
    read(*,*) self%pib

    write(*,*) ''

  end subroutine fundar_pais

  !C_Paises methods
  
  subroutine adicionar_pais(self)
  
    class(C_Paises)             :: self
    
    class(C_Paises), pointer    :: novoPais
  
    call adicionar_lista(self)
    
    call self.obterUltimo(novoPais)
    
    call novoPais.fundar()
  
  end subroutine adicionar_pais
  
  subroutine explorar_pais(self)

    class(C_Paises)            :: self

    write(*,*) 'O pais ', trim(self%nome),','
    
    write(*,*) 'cuja capital eh ', trim(self%capital),','
    
    write(*,*) 'tem uma populacao de', self%pop,'habitantes'
    
    write(*,*) 'e um pib de ', self%pib, 'milhoes de euros.'

  end subroutine explorar_pais
  
  subroutine mostrar_paises(self)
  
    class(C_Paises)             :: self
    
    class(C_Paises), pointer    :: pais => null()
    
    do while( self.paraCada(pais) )
    
      call pais.explorar()
    
    end do
  
    write(*,*) 'Paises mostrados.'

    write(*,*) ''

  end subroutine mostrar_paises

end module class_paises

!----------------- Programa ----------------------

program unitTests_paises

  use class_paises

  implicit none

  integer                 :: i

  !Inovação: destruamos o Me e conseguiremos
  !criar naturalmente várias instâncias de
  !atlases (ou colecções de mapas).

  class(C_Paises)            :: mapaTerrestre
        
  class(C_Paises)            :: mapaLunar

  !Descobrir e explorar a Terra

  do i=1,2

    call mapaTerrestre.adicionar()

  enddo
        
  call mapaTerrestre.mostrar()
  
  call mapaTerrestre.finalizar()
  
  call mapaTerrestre.mostrar()

  pause
  
  !Descobrir e explorar a Lua

  call mapaLunar.fundar()
  
  call mapaLunar.explorar()
  
  call mapaLunar.finalizar()

  call mapaTerrestre.mostrar()

  pause

end program unitTests_paises