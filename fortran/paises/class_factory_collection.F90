#ifndef _OBJSTR_LENGTH
#define _OBJSTR_LENGTH 128
#endif _OBJSTR_LENGTH

module class_collection

  !Regra 1: When using classes in fortran 2003, try considering that 'target' 
  !is a forbidden directive, except in 'get', 'set' and 'has' methods.
  !Regra 2: Encapsular em procedures os usos de 'associated' com retorno
  !de resultado verdadeiro/falso.
  !Regra 3: Para cada campo num tipo, tem que haver um metodo "defineCampo"
  !e um metodo "obterCampo".

  implicit none

  private

 !----------------------type C_objecto------------------------------!

 ! Regra 1: Todos os tipos tem que ser tipos derivados de C_objecto.
 ! Regra 2: Cada variável derivada do tipo C_objecto tem que ter 
 ! o campo tipoObj inicializado com o nome do tipo.

  type, abstract, public :: C_objecto

    character(len=_OBJSTR_LENGTH)       :: tipoObj = "C_objecto"

  contains
 
    procedure, pass(self)               :: defineTipoObj
    procedure, pass(self)               :: obterTipoObj

  end type C_objecto

  !----------------end type C_objecto------------------------------!

  !----------------type C_colecao---------------------------------!

  type, public, abstract, extends(C_objecto)  ::  C_colecao

    integer                        :: id = 0
    character(len=_OBJSTR_LENGTH)  :: chave = "_"
    class(C_objecto),  pointer     :: valor => null()
    class(C_colecao),  pointer     :: fundador => null()
    class(C_colecao),  pointer     :: seguinte => null()

  contains

    !Constructors
    procedure                       :: iniciar => iniciar_lista
    !Sets
    procedure                       :: defineId
    procedure                       :: defineChave
    procedure                       :: defineValor
    procedure                       :: definePrimeiro
    procedure                       :: defineSeguinte
    !Gets
    procedure                       :: obterId
    procedure                       :: obterChave
    procedure                       :: obterValor
    procedure                       :: obterPrimeiro
    procedure                       :: obterSeguinte   
    !Has
    procedure                       :: temId
    procedure                       :: temChave
    procedure                       :: temValor
    procedure                       :: temPrimeiro 
    procedure                       :: temSeguinte 
    !C_colecao methods
    procedure                       :: obterProprio
    procedure                       :: adicionar_nodo 
    procedure                       :: paraCada
    procedure                       :: obter  
    procedure                       :: obterAnterior
    procedure                       :: obterUltimo 
    procedure                       :: mostrarId 
    procedure                       :: mostrar 
    procedure                       :: remover
    procedure                       :: tamanho
    !Destructors
    procedure                       :: finalizar => remover_lista

  end type C_colecao

  !-------------end type C_colecao-------------------------------------!

  !-------------type C_colecao_objecto--------------------------------!

  type, public, extends(C_colecao)     :: C_colecao_objecto
    contains
  end type C_colecao_objecto

  !-------------end type C_colecao_objecto----------------------------!

  !-------------type C_colecao_colecao---------------------------------!

  type, public, extends(C_colecao)     :: C_colecao_colecao
    contains
  end type C_colecao_colecao

  !-------------end type C_colecao_colecao-----------------------------!

contains

  !----------------type-bound procedures of type C_objecto--------------!

  function obterTipoObj(self) result(str)
    class(C_objecto), intent(in)     :: self
    character(len=_OBJSTR_LENGTH)    :: str
    str = self%tipoObj
  end function obterTipoObj

  subroutine defineTipoObj(self, str)
    class(C_objecto), intent(inout)  :: self
    character(len=_OBJSTR_LENGTH)    :: str
    self%tipoObj = str
  end subroutine defineTipoObj

  !----------------end of type-bound procedures of type C_objecto-------!

  !----------------type-bound procedures of type C_colecao-------------!

  !Constructors

  subroutine iniciar_lista(self, id)

    class(C_colecao)                   :: self
    class(C_colecao), pointer          :: ptr
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
      call self%defineTipoObj(string)
      write(*,*) 'Criado item numero ', self.obterId()
    end if

  end subroutine iniciar_lista

  !Sets

  subroutine defineId(self, id)
    class(C_colecao)             :: self
    integer                       :: id
    self%id = id
  end subroutine defineId

  subroutine defineChave(self, chave)
    class(C_colecao)             :: self
    character(len=_OBJSTR_LENGTH) :: chave
    self%chave = chave
  end subroutine defineChave

  subroutine defineValor(self,valor)
    class(C_colecao)             :: self
    class(C_objecto), pointer     :: valor
    self%valor => valor
  end subroutine definevalor

  subroutine definePrimeiro(self, primeiro)
    class(C_colecao)              :: self
    class(C_colecao), pointer     :: primeiro
    self%fundador => primeiro
  end subroutine definePrimeiro

  subroutine defineSeguinte(self, seguinte)
    class(C_colecao)              :: self
    class(C_colecao), pointer     :: seguinte
    self%seguinte => seguinte
  end subroutine defineSeguinte

  !Gets
  !It is safer to avoid getting pointers on function returns
  !as they are not (yet as of ifort 12.0) usable directly
  !as arguments. To get pointers it's  best to use
  !subroutine calls.
  !Regra: devido a limitacao do ifort12.0, usar subroutines
  !para obter apontadores. Pode-se usar functions (que é melhor)
  !para obter escalares.

  subroutine obterProprio(self, proprio)
    class(C_colecao), target                    :: self
    class(C_colecao), pointer, intent(out)      :: proprio
    proprio => self
  end subroutine obterProprio

  function obterId(self) result(id)
    class(C_colecao)              :: self
    integer                        :: id
    id = self%id
  end function obterId

  function obterChave(self) result(chave)
    class(C_colecao)               :: self
    character(len=_OBJSTR_LENGTH)   :: chave
    chave = self%chave
  end function obterChave

  subroutine obterValor(self, valor)
    class(C_colecao)                       :: self
    class(C_objecto), pointer, intent(out)  :: valor
    valor => self%valor
  end subroutine obterValor

  subroutine obterPrimeiro(self, primeiro)
    class(C_colecao)                          :: self
    class(C_colecao), pointer, intent(out)    :: primeiro
    primeiro => self%fundador
  end subroutine obterPrimeiro

  subroutine obterSeguinte(self, seguinte)

    class(C_colecao)                        :: self
    class(C_colecao), pointer, intent(out)  :: seguinte

    if ( self.temSeguinte() ) then
      seguinte => self%seguinte
    else
      nullify( seguinte )
    end if

  end subroutine obterSeguinte

  !Has methods

  function temId(self) result(tem)

    class(C_colecao)             :: self
    logical                       :: tem

    if ( self%id .ne. 0 ) then
      tem = .true.
    else
      tem = .false.
    endif

  end function temId

  function temChave(self) result(tem)
    
    class(C_colecao)             :: self
    logical                       :: tem

    if ( trim(self%chave) .ne. "_" ) then
      tem = .true.
    else
      tem = .false.
    endif

  end function temChave

  function temValor(self) result(tem)

    class(C_colecao)             :: self
    logical                       :: tem

    if ( associated(self%valor) ) then
      tem = .true.
    else
      tem = .false.
    endif

  end function temValor

  function temPrimeiro(self) result(tem)
  
    class(C_colecao)             :: self
    logical                       :: tem

    if ( associated( self%fundador ) ) then
      tem = .true.
    else
      tem = .false.
    end if

  end function temPrimeiro

  function temSeguinte(self) result(tem)

    class(C_colecao)               :: self
    logical                         :: tem

    if ( associated( self%seguinte ) ) then     
      tem = .true.
    else
      tem = .false.
    end if

  end function temSeguinte

  !C_colecao methods
  
  subroutine adicionar_nodo(self)

    class(C_colecao)              :: self
    class(C_colecao), pointer     :: ultimo, new, primeiro

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

  end subroutine adicionar_nodo

  function paraCada(self, node) result(keepup)

    !Simulates 'for each <item> in <List> do ... end do'
    !usage: do while ( Lista.paraCada (item) )
    !usage: ...
    !usage: end do

    class(C_colecao)                             :: self
    class(C_colecao), pointer, intent(inout)     :: node
    logical                                       :: keepup    
    class(C_colecao), pointer                    :: node, nodeZero => null()

    if ( .not. associated( curr_node ) ) then

      allocate( nodeZero )
      call nodeZero%defineId(0)
      call self%obterPrimeiro( node )
      call nodeZero%definePrimeiro( node )
      call node%obterSeguinte( node )
      call nodeZero%defineSeguinte( node )
      node => nodeZero

    end if

    if ( node.temSeguinte() ) then
      call node.obterSeguinte(node)
      keepup = .true.
    else
      nullify( node )      
      keepup = .false.
    end if

    if ( associated( nodeZero ) ) then
      deallocate( nodeZero )
    end if

  end function paraCada

  subroutine obter(self, id, nodo)

    class(C_colecao)                            :: self
    integer                                      :: id    
    class(C_colecao), pointer, intent(out)      :: nodo

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

    class(C_colecao)                            :: self
    class(C_colecao), pointer, intent(out)      :: anterior   
    class(C_colecao), pointer                   :: seguinte

    call self.obterPrimeiro(anterior)

    if ( self.obterId() .ne. anterior.obterId() ) then

      call anterior.obterSeguinte(seguinte)

      do while ( seguinte.obterId() .ne. self.obterId() )
        if ( seguinte.temSeguinte() ) then
          call anterior.obterSeguinte(anterior)
          call seguinte.obterSeguinte(seguinte)
        else
          write(*,*) 'WARN 001: Nao foi encontrado o nodo anterior na colecao'
          write(*,*) 'C_colecao corrompida.'
          exit          
        endif
      end do

    endif

  end subroutine obterAnterior

  subroutine obterUltimo(self, ultimo)

    class(C_colecao)                            :: self
    class(C_colecao), pointer, intent(out)      :: ultimo

    call self.obterProprio(ultimo)

    do while ( ultimo.temSeguinte() )
      call ultimo.obterSeguinte(ultimo)
    end do

  end subroutine obterUltimo

  subroutine mostrarId(self)

    class(C_colecao)          :: self
    class(C_colecao), pointer :: ptr

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

    class(C_colecao)          :: self
    class(C_colecao), pointer :: item => null()

    do while ( self.paraCada(item) )
      call item.mostrarId()
    end do

    write(*,*) 'Lista de factory_collection mostrada.'
    write(*,*) ''

  end subroutine mostrar

  subroutine remover(self)

    class(C_colecao)             :: self
    class(C_colecao), pointer    :: ultimo, penultimo, ptr

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

  subroutine remover_lista(self)

    class(C_colecao)              :: self
    class(C_colecao), pointer     :: first

    call self.obterPrimeiro(first)

    do while ( first.temSeguinte() )
      call first.remover()
    end do

    write(*,*) 'Lista de factory_collection esvaziada.'
    write(*,*) ''

  end subroutine remover_lista

  function tamanho(self) result(tam)

    class(C_colecao)             :: self
    class(C_colecao), pointer    :: item => null()
    integer                       :: tam

    tam = 0

    do while ( self%paraCada(item) )    
      tam = tam + 1
    enddo

  end function tamanho

  !-----------end type-bound procedures of type C_colecao----------!

  !-----------type-bound procedures of type C_colecao_objecto-----!

  function paraCada_objecto(self, ptr, item) result(keepup)

    class(C_colecao)                             :: self
    class(C_colecao), pointer, intent(inout)     :: ptr
    class(C_objecto), pointer, intent(inout)     :: item
    logical                                       :: keepup

    call self%obterValor(item)

    if ( self%temSeguinte() ) then
      self%obterSeguinte(ptr)
      keepup = .true.
    else
      self%obterPrimeiro(ptr)
      keepup = .false.
    endif

  end function paraCada_objecto

  !-----------end type-bound procedures of type C_colecao_objecto--!

end module class_collection

!----------------- Program -----------------------------

program unitTests_lista_colecao

  use class_collection

  implicit none

  integer                     :: i

  type(C_colecao)       :: lista

  do i = 1, 15
    call lista%adicionar_nodo()
  end do

  write(*,*) ''
  call lista%mostrar()
  call lista%finalizar()
  call lista%mostrar()  
  pause

end program unitTests_lista_colecao
