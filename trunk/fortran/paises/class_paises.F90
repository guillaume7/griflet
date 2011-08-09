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

    procedure :: fundar         => fundar_pais

    !Sets

    !Gets
    
    procedure  obterProprio     => obterProprio_pais
    
    procedure  obterPrimeiro    => obterPrimeiro_pais
    
    procedure  obterSeguinte    => obterSeguinte_pais

    !C_Paises methods
    
    procedure  obterUltimo      => obterUltimo_pais
    
    procedure  obterAnterior    => obterAnterior_pais

    procedure  adicionar        => adicionar_pais

    procedure  explorar         => explorar_pais
    
    procedure  mostrar          => mostrar_paises
    
    procedure  paraCada         => paraCada_pais

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
  
  !Gets
  
  subroutine obterProprio_pais(self, proprio)

    class(C_Paises), target                    :: self

    class(C_Paises), pointer, intent(out)      :: proprio

    proprio => self

  end subroutine obterProprio_pais
  
  subroutine obterPrimeiro_pais(self, primeiro)

    class(C_Paises)                          :: self

    class(C_Paises), pointer, intent(out)    :: primeiro

    primeiro => self%fundador

  end subroutine obterPrimeiro_pais

  subroutine obterSeguinte_pais(self, seguinte)

    class(C_Paises)                        :: self

    class(C_Paises), pointer, intent(out)  :: seguinte

    if ( self.temSeguinte() ) then

      seguinte => self%seguinte

    else

      nullify( seguinte )

    end if

  end subroutine obterSeguinte_pais

  !C_Paises methods
  
  subroutine obterAnterior_pais(self, anterior)

    class(C_Paises)                            :: self

    class(C_Paises), pointer, intent(out)      :: anterior
    
    class(C_Paises), pointer                   :: seguinte

    call self.obterPrimeiro(anterior)

    if ( self.obterId() .ne. anterior.obterId() ) then

      call anterior.obterSeguinte(seguinte)

      do while ( seguinte.obterId() .ne. self.obterId() )

        if ( seguinte.temSeguinte() ) then

          call anterior.obterSeguinte(anterior)

          call seguinte.obterSeguinte(seguinte)

        else

          write(*,*) 'WARN 001: Nao foi encontrado o nodo anterior na colecao'

          write(*,*) 'Colecao corrompida.'

          exit
          
        endif

      end do

    endif

  end subroutine obterAnterior_pais

  subroutine obterUltimo_pais(self, ultimo)

    class(C_Paises)                            :: self

    class(C_Paises), pointer, intent(out)      :: ultimo

    call self.obterProprio(ultimo)

    do while ( ultimo.temSeguinte() )

      call ultimo.obterSeguinte(ultimo)

    end do

  end subroutine obterUltimo_pais

  subroutine adicionar_pais(self)
  
    class(C_Paises)             :: self
    
    class(C_Paises), pointer    :: novoPais
  
    call adicionar_lista(self)
    
    !call self.obterUltimo(novoPais)
    
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
    
    !do while( self.paraCada(pais) )
    
    !  call pais.explorar()
    
    !end do
  
    write(*,*) 'Paises mostrados.'

    write(*,*) ''

  end subroutine mostrar_paises

  function paraCada_pais(self, item) result(keepup)

    !Simulates 'for each <item> in <List> do ... end do'

    !usage: do while ( Lista.paraCada (item) )

    !usage: ...

    !usage: end do

    class(C_Paises)                             :: self

    class(C_Paises), pointer, intent(inout)     :: item

    class(C_Paises), pointer                    :: ptr, itemZero => null()

    logical                                      :: keepup

    if ( .not. associated( item ) ) then

      allocate( itemZero )

      call itemZero.defineId(0)

      call self.obterPrimeiro(ptr)

      call itemZero.definePrimeiro( ptr )

      call self.obterProprio(ptr)

      call itemZero.defineSeguinte( ptr )

      item => itemZero

    end if

    if ( item.temSeguinte() ) then

      call item.obterSeguinte(item)
  
      keepup = .true.

    else

      nullify( item )
      
      keepup = .false.

    end if

    if ( associated( itemZero ) ) then

      deallocate( itemZero )

    end if

  end function paraCada_pais
  
end module class_paises

!----------------- Programa ----------------------

program unitTests_paises

  use class_paises

  implicit none

  integer                 :: i

  !Inovação: destruamos o Me e conseguiremos
  !criar naturalmente várias instâncias de
  !atlases (ou colecções de mapas).

  type(C_Paises)            :: mapaTerrestre

  type(C_Paises)            :: mapaLunar

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