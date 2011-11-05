#ifndef _CLASS_COLECAO
#define _CLASS_COLECAO class_collection
#endif

#ifndef _C_COLECAO
#define _C_COLECAO C_factory
#endif

#ifndef _C_OBJECT
#define _C_OBJECT C_object
#endif _C_OBJECT

#ifndef _OBJSTR_LENGTH
#define _OBJSTR_LENGTH 128
#endif _OBJSTR_LENGTH

module _CLASS_COLECAO

  !Regra 1: When using classes in fortran 2003, try considering that 'target' 
  !is a forbidden directive, except in 'get', 'set' and 'has' methods.
  !Regra 2: Encapsular em procedures os usos de 'associated' com retorno
  !de resultado verdadeiro/falso.
  !Regra 3: Para cada campo num tipo, tem que haver um metodo "defineCampo"
  !e um metodo "obterCampo".

  implicit none

  private

 !----------------------type _C_OBJECT------------------------------!

 ! Regra 1: Todos os tipos tem que ser tipos derivados de _C_OBJECT.
 ! Regra 2: Cada variável derivada do tipo _C_OBJECT tem que ter 
 ! o campo tipoObj inializado com o nome do tipo.

  type, abstract, public :: _C_OBJECT

    character(len=_OBJSTR_LENGTH)       :: tipoObj = "_C_OBJECT"

  contains
 
    procedure, pass(self)               :: defineTipoObj !
    procedure, pass(self)               :: obterTipoObj !

  end type _C_OBJECT

!  abstract interface
!    function generic_getObjType(self) result(typeStr)
!      import :: _C_OBJECT
!      class(_C_OBJECT), intent(in)      :: self
!      character(len=_OBJSTR_LENGTH)     :: typeStr
!    end function generic_getObjType
!  end interface

  !----------------end type _C_OBJECT------------------------------!

  !----------------type _C_COLECAO---------------------------------!

  type, public, extends(_C_OBJECT) ::  _C_COLECAO

    integer                          :: id = 0
    character(len=_OBJSTR_LENGTH)    :: chave = "_"
    class(_C_OBJECT),   pointer      :: valor => null()
    class(_C_COLECAO),  pointer      :: fundador => null()
    class(_C_COLECAO),  pointer      :: seguinte => null()

  contains

    !Constructors
    procedure                       :: iniciar
    !Sets
    procedure                       :: defineId
    procedure                       :: defineChave !
    procedure                       :: defineValor !
    procedure                       :: definePrimeiro
    procedure                       :: defineSeguinte
    !Gets
    procedure                       :: obterId
    procedure                       :: obterChave !
    procedure                       :: obterValor !
    procedure                       :: obterPrimeiro
    procedure                       :: obterSeguinte   
    !Has
    procedure                       :: temId
    procedure                       :: temChave !
    procedure                       :: temValor !
    procedure                       :: temPrimeiro 
    procedure                       :: temSeguinte 
    !_C_COLECAO methods
    procedure                       :: obterProprio
    procedure                       :: adicionar 
    procedure                       :: paraCada 
    procedure                       :: obter  
    procedure                       :: obterAnterior
    procedure                       :: obterUltimo 
    procedure                       :: mostrarId 
    procedure                       :: mostrar 
    procedure                       :: remover
    procedure                       :: tamanho !
    !Destructors
    procedure                       :: finalizar

  end type _C_COLECAO

  !-------------end type _C_COLECAO-------------------------------------!

contains

  !----------------type-bound procedures of type _C_OBJECT--------------!

  function getObjType(self) result(str)

    class(_C_OBJECT), intent(in)     :: self

    character(len=_OBJSTR_LENGTH)    :: str

    str = self%objType

  end function getObjType

  subroutine setObjType(self, str)

    class(_C_OBJECT), intent(inout)  :: self

    character(len=_OBJSTR_LENGTH)    :: str

    self%objType = str

  end subroutine setObjType

  !----------------end of type-bound procedures of type _C_OBJECT-------!

  !----------------type-bound procedures of type _C_COLECAO-------------!

  !Constructors

  subroutine iniciar(self, id)

    class(_C_COLECAO)                   :: self

    class(_C_COLECAO), pointer          :: ptr

    integer, optional                   :: id

    character(len=_OBJSTR_LENGTH)       :: string = 'Colecao'


    if ( .not. self.temPrimeiro() ) then      

      if ( present( id ) ) then

        call self.defineId( id )

      end if

      call self.obterProprio( ptr )

      call self.definePrimeiro( ptr )

      nullify( ptr )

      call self.defineSeguinte( ptr )
    
      call self%setObjType(string)

      write(*,*) 'Criado item numero ', self.obterId()

    end if

  end subroutine iniciar

  !Sets ( '%' allowed for writing )

  subroutine defineId(self, id)

    class(_C_COLECAO)              :: self

    integer                       :: id

    self%id = id

  end subroutine defineId

  subroutine definePrimeiro(self, primeiro)

    class(_C_COLECAO)              :: self

    class(_C_COLECAO), pointer     :: primeiro

    self%fundador => primeiro

  end subroutine definePrimeiro

  subroutine defineSeguinte(self, seguinte)

    class(_C_COLECAO)              :: self

    class(_C_COLECAO), pointer     :: seguinte

    self%seguinte => seguinte

  end subroutine defineSeguinte

  !Gets ( '%' allowed for reading)
  !It is safer to avoid getting pointers on function returns
  !as they are not (yet as of ifort 12.0) usable directly
  !as arguments. To get pointers it's  best to use
  !subroutine calls.

  subroutine obterProprio(self, proprio)

    class(_C_COLECAO), target                    :: self

    class(_C_COLECAO), pointer, intent(out)      :: proprio

    proprio => self

  end subroutine obterProprio

  function obterId(self) result(id)

    class(_C_COLECAO)              :: self

    integer                        :: id

    id = self%id

  end function obterId

  subroutine obterPrimeiro(self, primeiro)

    class(_C_COLECAO)                          :: self

    class(_C_COLECAO), pointer, intent(out)    :: primeiro

    primeiro => self%fundador

  end subroutine obterPrimeiro

  subroutine obterSeguinte(self, seguinte)

    class(_C_COLECAO)                        :: self

    class(_C_COLECAO), pointer, intent(out)  :: seguinte

    if ( self.temSeguinte() ) then

      seguinte => self%seguinte

    else

      nullify( seguinte )

    end if

  end subroutine obterSeguinte

  !Has methods

  function temPrimeiro(self) result(tem)
  
    class(_C_COLECAO)              :: self

    logical                       :: tem

    if ( associated( self%fundador ) ) then

      tem = .true.

    else

      tem = .false.

    end if

  end function temPrimeiro

  function temSeguinte(self) result(tem)

    class(_C_COLECAO)              :: self

    logical                       :: tem

    if ( associated( self%seguinte ) ) then
      
      tem = .true.

    else

      tem = .false.

    end if

  end function temSeguinte

  !_C_COLECAO methods
  
  subroutine adicionar(self)

    class(_C_COLECAO)              :: self

    class(_C_COLECAO), pointer     :: ultimo, new, primeiro

    if ( .not. self.temPrimeiro() ) then

      call self.iniciar(1)

    end if

    call self.obterPrimeiro(primeiro)

    call self.obterUltimo(ultimo)

    allocate(new)
    
    call new.defineId( ultimo.obterId() + 1 )

    call new.definePrimeiro( primeiro )

    call ultimo.defineSeguinte( new )

    write(*,*) 'Criado item numero ', new.obterId()

  end subroutine adicionar

  function paraCada(self, item) result(keepup)

    !Simulates 'for each <item> in <List> do ... end do'

    !usage: do while ( Lista.paraCada (item) )

    !usage: ...

    !usage: end do

    class(_C_COLECAO)                             :: self

    class(_C_COLECAO), pointer, intent(inout)     :: item

    class(_C_COLECAO), pointer                    :: ptr, itemZero => null()

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

  end function paraCada

  subroutine obter(self, id, nodo)

    class(_C_COLECAO)                            :: self

    integer                                     :: id
    
    class(_C_COLECAO), pointer, intent(out)      :: nodo

    call self.obterPrimeiro(nodo)

    do while ( nodo.obterId() .ne. id )

      if ( nodo.temSeguinte() ) then

        call nodo.obterSeguinte(nodo)

      else

        id = nodo.obterId()

        write(*,*) 'WARN 000: Nao se encontrou o nodo ', id, ' na colecao.'

      end if

    end do

  end subroutine obter

  subroutine obterAnterior(self, anterior)

    class(_C_COLECAO)                            :: self

    class(_C_COLECAO), pointer, intent(out)      :: anterior
    
    class(_C_COLECAO), pointer                   :: seguinte

    call self.obterPrimeiro(anterior)

    if ( self.obterId() .ne. anterior.obterId() ) then

      call anterior.obterSeguinte(seguinte)

      do while ( seguinte.obterId() .ne. self.obterId() )

        if ( seguinte.temSeguinte() ) then

          call anterior.obterSeguinte(anterior)

          call seguinte.obterSeguinte(seguinte)

        else

          write(*,*) 'WARN 001: Nao foi encontrado o nodo anterior na colecao'

          write(*,*) '_C_COLECAO corrompida.'

          exit
          
        endif

      end do

    endif

  end subroutine obterAnterior

  subroutine obterUltimo(self, ultimo)

    class(_C_COLECAO)                            :: self

    class(_C_COLECAO), pointer, intent(out)      :: ultimo

    call self.obterProprio(ultimo)

    do while ( ultimo.temSeguinte() )

      call ultimo.obterSeguinte(ultimo)

    end do

  end subroutine obterUltimo

  subroutine mostrarId(self)

    class(_C_COLECAO)          :: self

    class(_C_COLECAO), pointer :: ptr

    call self.obterAnterior(ptr)

    if ( self.obterId() .eq. ptr.obterId() ) then

      write(*,*) 'O item e o fundador da lista de factory_collection.'

    else

      write(*,*) 'O item anterior tem numero ', ptr.obterId()

    end if

    write(*,*) 'O numero do item e o ', self.obterId()

    call self.obterSeguinte(ptr)

    if ( .not. self.temSeguinte() ) then

      write(*,*) 'O item e o ultimo da lista de factory_collection.'

    else

      write(*,*) 'O item seguinte tem numero', ptr.obterId()

    end if

    write(*,*) ''

  end subroutine mostrarId

  subroutine mostrar(self)

    class(_C_COLECAO)          :: self

    class(_C_COLECAO), pointer :: item => null()

    do while ( self.paraCada(item) )

      call item.mostrarId()

    end do

    write(*,*) 'Lista de factory_collection mostrada.'

    write(*,*) ''

  end subroutine mostrar

  subroutine remover(self)

    class(_C_COLECAO)             :: self

    class(_C_COLECAO), pointer    :: ultimo, penultimo, ptr

    call self.obterUltimo(ultimo)

    call ultimo.obterAnterior(penultimo)

    if ( ultimo.obterId() .eq. penultimo.obterId() ) then

      write(*,*) 'WARN: A lista contem apenas o seu elemento fundador.'

      write(*,*) 'Não se remove o elemento fundador da lista.'

      write(*,*) 'O elemento fundador so pode ser removido externamente.'

    else

      write(*,*) 'Removido item numero ', ultimo.obterId()

      deallocate(ultimo)

    endif

    nullify( ptr )

    call penultimo.defineSeguinte( ptr )

  end subroutine remover

  !Destructors

  subroutine finalizar(self)

    class(_C_COLECAO)              :: self

    class(_C_COLECAO), pointer     :: first

    call self.obterPrimeiro(first)

    do while ( first.temSeguinte() )

      call first.remover()

    end do

    write(*,*) 'Lista de factory_collection esvaziada.'

    write(*,*) ''

  end subroutine finalizar

  !-----------end type-bound procedures of type _C_COLECAO--------!

end module _CLASS_COLECAO

!----------------- Program -----------------------------

program unitTests_lista_colecao

  use _CLASS_COLECAO

  implicit none

  integer                     :: i

  type(_C_COLECAO)       :: lista

  do i = 1, 15

    call lista.adicionar()

  end do

  write(*,*) ''

  call lista.mostrar()

  call lista.finalizar()

  call lista.mostrar()
  
  pause

end program unitTests_lista_colecao
