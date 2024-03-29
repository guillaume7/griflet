module class_pais

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

    procedure :: adicionar  => adicionar_pais

    procedure :: explorar   => explorar_pais

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
    
    novoPais => self.obterUltimo()
    
    call novoPais.fundar()
  
  end subroutine adicionar_pais
  
  subroutine explorar_pais(pais)

    class(C_Paises)            :: pais

    write(*,*) 'O pais ', trim(pais%nome),','
    
    write(*,*) 'cuja capital eh ', trim(pais%capital),','
    
    write(*,*) 'tem uma populacao de', pais%pop,'habitantes'
    
    write(*,*) 'e um pib de ', pais%pib, 'milhoes de euros.'

  end subroutine explorar_pais

end module class_pais

!----------------- Programa ----------------------

program progMapaMundoTres

  use moduleMapaMundoTres

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
        
  !Descobrir e explorar a Lua

  call mapaLunar.fundar()

  pause

end program progMapaMundoTres