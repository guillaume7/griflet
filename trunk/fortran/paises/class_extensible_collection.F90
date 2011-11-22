#ifndef _OBJSTR_LENGTH
#define _OBJSTR_LENGTH 128
#endif

! TODO: 
! 1 - Opção de Chave (define, search) DONE
! 1a- Mudar o tamanho fixo das chaves de 128 caracteres para um tamanho indefinido...
!   - Feito : criei a função pública str() que converte strings de qq tamanho
!     em strings com o tamanho certo. DONE
! 2 - Extender C_Colecao para C_Colecao_objecto (C_Colecao_Colecao é inválido pq C_Colecao é abstrato).
!     Criar interfaces para os metodos associados ao Valor. DONE
! 2a- Criar tipos derivados de objecto "Apple" e "Banana --> Conumdrum --> refactor!
! 2b- Refactorizar tudo: Para qualquer tipo genérico "apple", "banana" ...
!       ... existe um apontador para null na classe C_Capsula.
!       O campo "valor" da classe C_Colecao é um apontador
!       para null do tipo C_Capsula.
!       Existem extensoes opcionais da classe C_Colecao
!       denominadas "C_Colecao_apple", "C_Colecao_banana", ...
! 3 - Fazer programa com arrays e com directivas openmp,
!     pensar numa alternativa ao do while( paraCada() )
!     para criar uma zona paralelizada segura ( threadSafe ).

module class_collection

  !Regra 1: When using classes in fortran 2003, try considering that 'target' 
  !is a forbidden directive, except in 'get', 'set' and 'has' methods.
  !Regra 2: Encapsular em procedures os usos de 'associated' com retorno
  !de resultado verdadeiro/falso.
  !Regra 3: Para cada campo num tipo, tem que haver um metodo "defineCampo"
  !e um metodo "obterCampo".

  implicit none

  private

 ! Os tipos Objecto e Maca são exemplos de objectos que podem
 ! encapsulados e colocados numa pilha (C_Colecao).

 !----------------------type C_Objecto------------------------------!

 ! Regra 1: Cada variável derivada do tipo C_Objecto tem que ter
 ! o campo tipoObj inicializado com o nome do tipo.
  type, public :: C_Objecto

    character(len=_OBJSTR_LENGTH)       :: tipoObj = "C_Objecto"


  contains
 
    procedure                           :: defineTipoObj
    procedure                           :: obterTipoObj
    procedure                           :: mostrarTipoObj

  end type C_Objecto

  !----------------end type C_Objecto------------------------------!

  !----------------type C_Maca------------------------------!

  type, public, extends(C_Objecto)      :: C_Maca
    character(len=_OBJSTR_LENGTH)       :: categoria = "Categoria Indefinida"
  contains
    procedure                           :: defineCategoria
    procedure                           :: obterCategoria
    procedure                           :: temCategoria
    procedure                           :: mostrarCategoria
  end type C_Maca

  !-------------end type C_Maca-----------------------------!

  ! Os tipos C_Capsula e C_Colecao sao os tipos importantes
  ! deste modulo.

  !----------------type C_Capsula------------------------------!

  type, public                          :: C_Capsula

    class(C_Objecto), pointer           :: Objecto => null()
    class(C_Maca), pointer              :: Maca => null()

  contains

    procedure, nopass                   :: nullProc

#undef _VALOR_
#define _VALOR_ Objecto
#include "C_Capsula.inc"

#undef _VALOR_
#define _VALOR_ Maca
#include "C_Capsula.inc"

  end type C_Capsula

  !-------------end type C_Capsula-----------------------------!

  !----------------type C_Colecao---------------------------------!

  type, public, extends(C_Objecto)  ::  C_Colecao

    integer                        :: id = 0
    character(len=_OBJSTR_LENGTH)  :: chave = "_"
    class(C_Colecao),  pointer     :: fundador => null()
    class(C_Colecao),  pointer     :: seguinte => null()
    class(C_Capsula),  pointer     :: valor => null()

  contains

    !Constructors
    procedure                       :: iniciar
    !Destructors
    procedure                       :: finalizar
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
    !Show
    procedure                       :: mostrarId
    procedure                       :: mostrarChave
    procedure                       :: mostrarValor

    !C_Colecao methods
    procedure                       :: obterProprio
    procedure                       :: obterAnterior
    procedure                       :: obterUltimo

    procedure                       :: mostrar
    procedure                       :: mostrarNodo

    procedure                       :: adicionar
    procedure			            :: adicionarNodoSemOValor
    procedure(gen_adicionarValor), deferred     :: adicionarValor

    procedure(gen_alocarNodo), deferred, nopass :: alocarNodo
!    procedure(gen_alocarValor), deferred        :: alocarValor

    procedure, nopass               :: desalocarNodo
!    procedure(gen_desalocarValor), deferred     :: desalocarValor

    procedure                       :: paraCada
    procedure                       :: remover
    procedure                       :: tamanho
    procedure 			            :: existeChave

    procedure                       :: procura
    procedure                       :: procuraId
    procedure                       :: procuraChave

    procedure                       :: redefineId
    procedure                       :: redefinePrimeiro

  end type C_Colecao

  abstract interface

    subroutine gen_alocarNodo ( new )
      import 		:: C_Colecao
      class(C_Colecao), pointer, intent(inout)	:: new
    end subroutine gen_alocarNodo

    subroutine gen_defineValor (self, valor)
      import 		:: C_Colecao
      import 		:: C_Objecto
      class(C_colecao)                    :: self
      class(C_objecto), pointer     	  :: valor
    end subroutine gen_defineValor

    subroutine gen_obterValor (self, valor)
      import 		:: C_Colecao
      import 		:: C_Objecto
      class(C_colecao)                              :: self
      class(C_objecto), pointer, intent(out)        :: valor
    end subroutine gen_obterValor

    function gen_temValor (self) result(tem)
      import 		:: C_Colecao
      class(C_colecao)              :: self
      logical                       :: tem
    end function gen_temValor

    subroutine gen_mostrarValor(self)
      import 		:: C_Colecao
      class(C_colecao)              :: self
    end subroutine gen_mostrarValor

    subroutine gen_adicionarValor (self, valor)
      import 		:: C_Colecao
      import 		:: C_Objecto
      class(C_colecao)                                  :: self
      class(C_objecto), pointer, intent(in)           	:: valor
    end subroutine gen_adicionarValor

    subroutine gen_alocarValor (self)
      import 		:: C_Colecao
      class(C_colecao)                                  :: self
    end subroutine gen_alocarValor

    subroutine gen_desalocarValor (self)
      import 		:: C_Colecao
      class(C_colecao)                                  :: self
    end subroutine gen_desalocarValor

  end interface

  !-------------end type C_Colecao-------------------------------------!

  public                :: str

contains

  !----------------type-bound procedures of type C_Objecto--------------!

  subroutine defineTipoObj(self, str)
    class(C_Objecto)                 :: self
    character(len=_OBJSTR_LENGTH)    :: str
    self%tipoObj = str
  end subroutine defineTipoObj

  function obterTipoObj(self) result(str)
    class(C_Objecto), intent(in)     :: self
    character(len=_OBJSTR_LENGTH)    :: str
    str = self%tipoObj
  end function obterTipoObj

  subroutine mostrarTipoObj(self)
    class(C_Objecto)                    :: self
    character(len=_OBJSTR_LENGTH)       :: str
    str = self%obterTipoObj()
    write(*,*) 'Elemento do tipo ', trim( self%obterTipoObj() )
  end subroutine mostrarTipoObj

  !----------------end of type-bound procedures of type C_Objecto-------!

  !----------type-bound procedures of type C_Maca---------------!

  subroutine defineCategoria(self, tipo)
    class(C_Maca)                   :: self
    integer                         :: tipo
    if ( tipo .eq. 1 ) then
      self%categoria = Str("Starking")
    elseif ( tipo .eq. 2 ) then
      self%categoria = Str("Golden")
    elseif ( tipo .eq. 3 ) then
      self%categoria = Str("Reinette")
    else
      self%categoria = Str("Appleseed")
    endif
  end subroutine defineCategoria

  function obterCategoria(self) result(acategoria)
    class(C_Maca)                   :: self
    character(len=_OBJSTR_LENGTH)   :: acategoria
    acategoria = self%categoria
  end function obterCategoria

  function temCategoria(self) result(tem)
    class(C_Maca)                   :: self
    logical                         :: tem
    if ( self%categoria .eq. "Categoria Indefinida" ) then
      tem = .false.
    else
      tem = .true.
    end if
  end function temCategoria

  subroutine mostrarCategoria(self)
    class(C_Maca)                   :: self
    write(*,*) 'Maca de categoria ', trim( self%obterCategoria() )
  end subroutine mostrarCategoria

  !----------end type-bound procedures of type C_Maca-----------!

  !----------type-bound procedures of type C_Capsula------------!

  subroutine nullProc()

  end subroutine nullProc

#undef _VALOR_
#define _VALOR_ Objecto
#include "C_Capsula_contains.inc"

#undef _VALOR_
#define _VALOR_ Maca
#include "C_Capsula_contains.inc"

  !----------end type-bound procedures of type C_Capsula--------!

  !----------------type-bound procedures of type C_Colecao-------------!

  !Constructors

  subroutine iniciar(self, id)

    class(C_Colecao)                   :: self
    class(C_Colecao), pointer          :: ptr
    integer, optional                  :: id
    character(len=_OBJSTR_LENGTH)      :: string = 'C_Colecao'

    if ( .not. self%temPrimeiro() ) then
      if ( present( id ) ) then
        call self%defineId( id )
      end if
      call self%obterProprio( ptr )
      call self%definePrimeiro( ptr )
      nullify( ptr )
      call self%defineSeguinte( ptr )
      call self%defineTipoObj( string )
      write(*,*) 'Criado item numero ', self%obterId()
    end if

  end subroutine iniciar

  !Destructors

  subroutine finalizar(self)

    class(C_Colecao)              :: self
    class(C_Colecao), pointer     :: first

    call self%obterPrimeiro(first)

    do while ( first%temSeguinte() )
      call first%remover()
    end do

    write(*,*) 'Lista esvaziada.'
    write(*,*) ''

  end subroutine finalizar

  !Sets

  subroutine defineId(self, id)
    class(C_Colecao)              :: self
    integer                       :: id
    self%id = id
  end subroutine defineId

  subroutine defineChave(self, chave)
    class(C_Colecao)              :: self
    character(len=_OBJSTR_LENGTH) :: chave
    if ( .not. self%existeChave(chave) ) then
      self%chave = trim(chave)
    else
      write(*,*) 'Error: defineChave - Chave already exists!'
    end if
  end subroutine defineChave

  subroutine defineValor (self, valor)
    class(C_Colecao)                :: self
    class(C_Capsula), pointer       :: valor
    self%valor => valor
  end subroutine defineValor

  subroutine definePrimeiro(self, primeiro)
    class(C_Colecao)              :: self
    class(C_Colecao), pointer     :: primeiro
    self%fundador => primeiro
  end subroutine definePrimeiro

  subroutine defineSeguinte(self, seguinte)
    class(C_Colecao)              :: self
    class(C_Colecao), pointer     :: seguinte
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
    class(C_Colecao), target                    :: self
    class(C_Colecao), pointer, intent(out)      :: proprio
    proprio => self
  end subroutine obterProprio

  function obterId(self) result(id)
    class(C_Colecao)              :: self
    integer                       :: id
    id = self%id
  end function obterId

  function obterChave(self) result(chave)
    class(C_Colecao)               :: self
    character(len=_OBJSTR_LENGTH)  :: chave
    chave = self%chave
  end function obterChave

  subroutine obterValor (self, valor)
    class(C_Colecao)                        :: self
    class(C_Capsula), pointer, intent(out)  :: valor
    valor => self%valor
  end subroutine obterValor

  subroutine obterPrimeiro(self, primeiro)
    class(C_Colecao)                          :: self
    class(C_Colecao), pointer, intent(out)    :: primeiro
    primeiro => self%fundador
  end subroutine obterPrimeiro

  subroutine obterSeguinte(self, seguinte)

    class(C_Colecao)                        :: self
    class(C_Colecao), pointer, intent(out)  :: seguinte

    if ( self%temSeguinte() ) then
      seguinte => self%seguinte
    else
      nullify( seguinte )
    end if

  end subroutine obterSeguinte

  !Has methods

  function temId(self) result(tem)

    class(C_Colecao)             :: self
    logical                       :: tem

    if ( self%id .ne. 0 ) then
      tem = .true.
    else
      tem = .false.
    endif

  end function temId

  function temChave(self) result(tem)
    
    class(C_Colecao)             :: self
    logical                       :: tem

    if ( trim(self%chave) .ne. "_" ) then
      tem = .true.
    else
      tem = .false.
    endif

  end function temChave

  function temValor (self) result(tem)
      class(C_Colecao)              :: self
      logical                       :: tem
      if ( associated(self%valor) ) then
        tem = .true.
      else
        tem = .false.
      endif
  end function temValor

  function temPrimeiro(self) result(tem)
  
    class(C_Colecao)             :: self
    logical                       :: tem

    if ( associated( self%fundador ) ) then
      tem = .true.
    else
      tem = .false.
    end if

  end function temPrimeiro

  function temSeguinte(self) result(tem)

    class(C_Colecao)               :: self
    logical                        :: tem

    if ( associated( self%seguinte ) ) then     
      tem = .true.
    else
      tem = .false.
    end if

  end function temSeguinte

  !Show
  subroutine mostrarId(self)

    class(C_Colecao)          :: self
    class(C_Colecao), pointer :: ptr

    call self%obterAnterior(ptr)

    write(*,*) ' '
    if ( self%obterId() .eq. ptr%obterId() ) then
      write(*,*) 'O item e o fundador da lista da colecao.'
    else
      write(*,*) 'O item anterior tem numero ', ptr%obterId()
    end if

    write(*,*) 'O numero do item e o ', self%obterId()

    call self%obterSeguinte(ptr)

    if ( .not. self%temSeguinte() ) then
      write(*,*) 'O item e o ultimo da lista.'
    else
      write(*,*) 'O item seguinte tem numero', ptr%obterId()
    end if

  end subroutine mostrarId

  subroutine mostrarChave(self)
    class(C_Colecao)                :: self
    write(*,*) 'a chave é "', trim(self%obterChave()),'".'
  end subroutine mostrarChave

  subroutine mostrarValor (self)
    class(C_Colecao)                :: self
    class(C_Capsula), pointer       :: valor
    call self%obterValor( valor )
    call valor%mostrar()
  end subroutine mostrarValor

  !C_Colecao methods

  subroutine mostrarNodo(self)

    class(C_Colecao)          :: self

    call self%mostrarId()
    if ( self%temChave() ) then
      call self%mostrarChave()
    end if
    if ( self%temValor() ) then
      call self%mostrarValor()
    end if

  end subroutine mostrarNodo

  subroutine mostrar(self)

    class(C_Colecao)          :: self
    class(C_Colecao), pointer :: item => null()

    do while ( self%paraCada(item) )
      call item%mostrarNodo()
    end do

    write(*,*) ''
    write(*,*) 'A lista contem ', self%tamanho(), ' elementos'
    write(*,*) 'Lista mostrada.'
    write(*,*) ''

  end subroutine mostrar

  subroutine adicionar(self, valor, chave)

    class(C_Colecao)                            :: self
    class(C_Capsule), pointer                   :: valor
    character(len=_OBJSTR_LENGTH), optional     :: chave
    class(C_Colecao), pointer                   :: nodo => null()

    if ( present( chave ) ) then
      call self%adicionarNodo( chave = chave )
    else
      call self%adicionarNodo()
    end if

    call self%obterUltimo( nodo )
    if ( associated( valor ) ) then
      call nodo%defineValor( valor )
    else
      write(*,*) 'Erro: a capsula a adicionar na pilha aponta para null()'
    end if

  end subroutine adicionar

  subroutine adicionarNodo(self, nodo, chave)

    class(C_Colecao)                                      :: self
    class(C_Colecao), pointer, intent(inout), optional    :: nodo
    character(len=_OBJSTR_LENGTH), optional		          :: chave
    class(C_Colecao), pointer                             :: ultimo, new => null(), primeiro

    if ( present( nodo ) ) then

      if ( associated( nodo ) ) then

        !'ptr' pode ser um simples nodo de colecao
        ! mas tambem pode representar uma colecao
        ! inteira.
        ! É sempre necessário redefinir o fundador
        ! e redefineIdr os ids.

        if ( .not. nodo%temPrimeiro() ) then
          call nodo%iniciar( 1 )
        endif

        if ( .not. self%temPrimeiro() ) then
          call self%definePrimeiro( nodo )
        else 
          call self%obterUltimo( ultimo )
          call ultimo%defineSeguinte( nodo )
          call self%obterPrimeiro( primeiro )
          call self%redefinePrimeiro( primeiro )
          call self%redefineId()
        endif
        
        call self%obterUltimo( ultimo )
        
        if ( nodo%obterId() .ne. ultimo%obterId() ) then
          write(*,*) 'Inserido item numero ', nodo%obterId() &
                   , ' até ', ultimo%obterId()
        else
          write(*,*) 'Inserido item numero ', nodo%obterId()
        end if

        if ( present( chave ) ) then
	  call nodo%defineChave(chave)
	end if

      else

        write(*,*) 'Error in adicionarNodoSemOValor: Passed argument points to null().'

      endif

    else

      if ( .not. self%temPrimeiro() ) then

        call self%iniciar( 1 )

      else   

        call self%obterPrimeiro(primeiro)
        call self%obterUltimo(ultimo)
        call self%alocarNodo( new )
        call new%defineId( ultimo%obterId() + 1 )
        call new%definePrimeiro( primeiro )
        call ultimo%defineSeguinte( new )
        if ( present( chave ) ) then
	  call new%defineChave(chave)
	end if
        write(*,*) 'Criado item numero ', new%obterId()
    
      end if

    end if

  end subroutine adicionarNodo

  function paraCada(self, node, valor) result(keepup)

    !Simulates 'for each <item> in <List> do %%% end do'
    !usage: do while ( Lista%paraCada (item) )
    !usage: %%%
    !usage: end do

    class(C_Colecao)                             	:: self
    class(C_Colecao), pointer, intent(inout)     	:: node
    class(C_Capsula), pointer, optional, intent(out)	:: valor
    logical                                      	:: keepup    
    class(C_Colecao), pointer                    	:: ptr, nodeZero => null()

    if ( .not. associated( node ) ) then

      call self%alocarNodo( nodeZero )
      call nodeZero%defineId(0)
      call self%obterPrimeiro( ptr )
      call nodeZero%definePrimeiro( ptr )
!      call self%obterProprio( ptr )
      call nodeZero%defineSeguinte( ptr )
      node => nodeZero

    end if

    if ( node%temSeguinte() ) then
      call node%obterSeguinte( node )
      if ( present( valor ) ) call node%obterValor( valor )
      keepup = .true.
    else
      nullify( node )
      if ( present( valor ) ) nullify( valor )
      keepup = .false.
    end if

    if ( associated( nodeZero ) ) then
      call self%desalocarNodo( nodeZero ) 
    end if

  end function paraCada

  function procuraId(self, id, nodo) result(found)
    class(C_Colecao)                            :: self
    integer                                     :: id
    class(C_Colecao), pointer, intent(out)      :: nodo
    logical					:: found
    class(C_Colecao), pointer		        :: item => null()
    found = .false.
    if ( id .le. self%tamanho() ) then
      do while ( self%paraCada(item) )
        if ( item%obterId() .eq. id ) then
	  found = .true.
          call item%obterProprio( nodo )
	  write(*,*) ' '
	  write(*,*) 'Encontrado o elemento da colecao com id ', id
        end if
      end do
    else
      write(*,*) 'O id', id,'que procura é superior ao tamanho da coleção', self%tamanho()
      nullify( nodo )
    end if
  end function procuraId

  subroutine obterAnterior(self, anterior)

    class(C_Colecao)                            :: self
    class(C_Colecao), pointer, intent(out)      :: anterior   
    class(C_Colecao), pointer                   :: seguinte

    call self%obterPrimeiro(anterior)

    if ( self%obterId() .ne. anterior%obterId() ) then

      call anterior%obterSeguinte(seguinte)

      do while ( seguinte%obterId() .ne. self%obterId() )
        if ( seguinte%temSeguinte() ) then
          call anterior%obterSeguinte(anterior)
          call seguinte%obterSeguinte(seguinte)
        else
          write(*,*) 'WARN 001: Nao foi encontrado o nodo anterior na colecao'
          write(*,*) 'C_Colecao corrompida.'
          exit          
        endif
      end do

    endif

  end subroutine obterAnterior

  subroutine obterUltimo(self, ultimo)

    class(C_Colecao)                              :: self
    class(C_Colecao), pointer, intent(inout)      :: ultimo

    call self%obterPrimeiro(ultimo)

    do while ( ultimo%temSeguinte() )
      call ultimo%obterSeguinte(ultimo)
    end do

  end subroutine obterUltimo


  subroutine remover(self)

    class(C_Colecao)             :: self
    class(C_Colecao), pointer    :: ultimo, penultimo, ptr

    call self%obterUltimo(ultimo)
    call ultimo%obterAnterior(penultimo)

    if ( ultimo%obterId() .eq. penultimo%obterId() ) then
      write(*,*) 'WARN: A lista contem apenas o seu elemento fundador.'
      write(*,*) 'Não se remove o elemento fundador da lista.'
      write(*,*) 'O elemento fundador so pode ser removido externamente.'
    else
      if ( ultimo%temValor() ) then
        call ultimo%desalocarValor()
      end if
      write(*,*) 'Removido item numero ', ultimo%obterId()
      call self%desalocarNodo( ultimo )
    endif

    nullify( ptr )
    call penultimo%defineSeguinte( ptr )

  end subroutine remover

  function tamanho(self) result(tam)

    class(C_Colecao)             :: self
    class(C_Colecao), pointer    :: item => null()
    integer                      :: tam

    tam = 0

    do while ( self%paraCada(item) )
      tam = tam + 1 
    enddo

  end function tamanho

  subroutine redefineId(self)

    class(C_Colecao)             :: self
    class(C_Colecao), pointer    :: item => null()
    integer                      :: i

    i = 1
    do while ( self%paraCada( item ) )
      call item%defineId( i )
      i = i + 1
    end do

  end subroutine redefineId

  subroutine redefinePrimeiro( self, primeiro )

    class(C_Colecao)                            :: self
    class(C_Colecao), pointer, intent(in)       :: primeiro
    class(C_Colecao), pointer                    :: item => null()

    if ( associated( primeiro ) ) then
      do while ( self%paraCada( item ) )
        call item%definePrimeiro( primeiro ) 
      end do
    else
      write(*,*) 'Error: redefinePrimeiro, passed argument points to null.'
    end if

  end subroutine redefinePrimeiro

  function existeChave(self, chave) result(existe)

    class(C_Colecao)				:: self
    character(len=_OBJSTR_LENGTH),intent(in)	:: chave
    logical					:: existe
    class(C_Colecao), pointer			:: item => null()

    existe = .false.
    do while ( self%paraCada( item ) )
      if ( trim(item%chave) .eq. trim(chave) ) then
        existe = .true.
      end if
    end do

  end function existeChave

  function procuraChave(self, chave, resultado) result(found)

    class(C_Colecao)				:: self
    character(len=_OBJSTR_LENGTH), intent(in)	:: chave
    class(C_Colecao), pointer, intent(inout)	:: resultado
    logical					:: found
    class(C_Colecao), pointer			:: item => null()
    
    found = .false.
    nullify( resultado )
    do while ( self%paraCada( item ) )
      if ( trim(item%obterChave()) .eq. trim(chave) ) then
	found = .true.
        call item%obterProprio( resultado )
        write(*,*) ' '
        write(*,*) 'Encontrada chave "', trim(chave), '" no elemento com id', item%obterId()
      end if
    end do

  end function procuraChave

  subroutine desalocarNodo ( ptr ) !nopass
    class(C_Colecao), pointer, intent(inout)	:: ptr
    if ( associated( ptr ) ) then
      deallocate( ptr )
      nullify( ptr )
    else
      write(*,*) 'Warning: desalocarNodo - argument already points to null.'
    endif
  end subroutine desalocarNodo

  function procura(self, resultado, valor, id, chave) result(found)
    class(C_Colecao)					:: self
    class(C_Colecao), pointer, intent(out)      	:: resultado
    class(C_Objecto), pointer, intent(out), optional	:: valor
    integer, optional					:: id
    character(len=_OBJSTR_LENGTH), optional		:: chave
    logical						:: found
    if ( present( id ) ) then
      found = self%procuraId( id, resultado )      
    elseif ( present( chave ) ) then
      found = self%procuraChave( chave, resultado )
    else
      write(*,*) 'Sem elemento de procura na colecao.'
      found = .false.
      nullify( resultado )
    endif
    if ( present( valor ) ) then
      if ( found ) then
        call resultado%obterValor( valor )
      else
        nullify( valor )
      endif
    endif
  end function procura

  !-----------end type-bound procedures type C_Colecao----------!

  function str(inStr) result(sizedStr)
    character(len=*), intent(in)        :: inStr
    character(len=_OBJSTR_LENGTH)       :: sizedStr
    sizedStr = trim(inStr)
  end function str

end module class_collection

!------------------ Program -----------------------------!

program unitTests_lista_colecao

  use class_collection

  implicit none

  !Regra: as variáveis de type são da classe extendida
  !mas as variáveis apontadores de classe são da classe abstracta

  type(C_Colecao_Maca)            :: caixa
  class(C_Maca), pointer          :: maca => null()
  class(C_Objecto), pointer       :: val => null()
  class(C_Colecao), pointer       :: nodo => null()
  integer                         :: i 

  !Programa que demonstra as features da classe C_Colecao
  !programada no standard Fortran2003.
  !A classe C_Colecao permite agrupar elementos dum tipo derivado
  !da classe C_Objecto numa pilha com indentificativo crescente 
  !começando em 1.
  !Os metodos mais usuais dessa colecao são
  ! - adicionar novos nodos à colecao ( no fim --> LIFO )
  ! - procura por um nodo por identificativo ou por chave
  ! - extrair o objecto dum nodo
  ! - mostrar toda a colecao ou mostrar um nodo da colecao
  ! - remover um nodo ( o ultimo --> LIFO )
  ! - remover todos os elementos da colecao menos o primeiro

  !Cria e adiciona 2 elementos que guarda na colecao
  do i = 1, 2
    call caixa%adicionar()
  end do

  !Cria e adiciona 1 elemento com uma chave associada.
  call caixa%adicionar( chave = str('Maçã especial') )

  !Procura o elemento da colecao contendo aquela chave
  !e mostra elemento
  if ( caixa%procura( nodo, chave = str('Maçã especial') ) ) then
    call nodo%mostrarNodo()
  end if

  !Procura o elemento número 2 da lista,
  !extrai o valor e mostra
  if ( caixa%procura( nodo, id = 2 ) ) then
    call nodo%obterValor( val )
    maca => val
    call maca%mostrarCategoria()
  end if

  !Igual ao anterior: procura, extrai valor e mostra
  if ( caixa%procura( nodo, valor = maca, id = 1 ) ) then
    call maca%mostrarCategoria()
  end if

  !Mostra toda a colecao de objectos
  call caixa%mostrar()

  !Faz a mesma coisa mas
  !utiliza o ciclo "for each" da colecao.
  nullify( nodo )
  do while( caixa%paraCada( nodo ) )
    call nodo%mostrarNodo( )
  enddo

  !Semelhante ao "for each" anterior
  !mas extrai o valor e mostra
  nullify( nodo )
  do while( caixa%paraCada( nodo, valor = maca ) )
    call maca%mostrarCategoria()
  enddo
 
  !Remove todos os itens da colecao
  !(excepto o item fundador da colecao)
  call caixa%finalizar()

  !Mostra o item fundador da colecao
  call caixa%mostrar()

  pause

end program unitTests_lista_colecao

