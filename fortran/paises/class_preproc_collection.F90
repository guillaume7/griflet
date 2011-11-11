!Regra: activar todos os tipos de colecao que
!se pretendem usar no projecto.
#define _OBJECTO_ Objecto
#define _COLECAO_ Colecao

#ifndef _OBJSTR_LENGTH
#define _OBJSTR_LENGTH 128
#endif

! TODO: 
! 1 - Opção de Chave * Done (define, search)
! 2 - Extender C_Colecao para C_Colecao_objecto e para C_Colecao_colecao.
!     Criar interfaces para os metodos associados ao Valor.
! 3 - Fazer programa com arrays e com directivas openmp,
!     pensar numa alternativa ao do while( paraCada() )
!     para criar uma zona paralelizada segura (threadSafe).

module class_collection

  !Regra 1: When using classes in fortran 2003, try considering that 'target' 
  !is a forbidden directive, except in 'get', 'set' and 'has' methods.
  !Regra 2: Encapsular em procedures os usos de 'associated' com retorno
  !de resultado verdadeiro/falso.
  !Regra 3: Para cada campo num tipo, tem que haver um metodo "defineCampo"
  !e um metodo "obterCampo".

  implicit none

  private

 !----------------------type C_Objecto------------------------------!

 ! Regra 1: Todos os tipos tem que ser tipos derivados de C_Objecto.
 ! Regra 2: Cada variável derivada do tipo C_Objecto tem que ter 
 ! o campo tipoObj inicializado com o nome do tipo.

  type, public :: C_Objecto

    character(len=_OBJSTR_LENGTH)       :: tipoObj = "C_Objecto"

  contains
 
    procedure                           :: defineTipoObj
    procedure                           :: obterTipoObj
    procedure                           :: mostrarTipoObj

  end type C_Objecto

  !----------------end type C_Objecto------------------------------!

  !----------------type C_Colecao---------------------------------!

  type, public, extends(C_Objecto)  ::  C_Colecao

    integer                        :: id = 0
    character(len=_OBJSTR_LENGTH)  :: chave = "_"
    class(C_Colecao),  pointer     :: fundador => null()
    class(C_Colecao),  pointer     :: seguinte => null()

    !Regra: Aqui definem-se apontadores para todos os tipos de 
    !objectos passiveis de fazer uma colecao
    class(C_Objecto), pointer      :: Objecto => null()
    class(C_Colecao), pointer	   :: Colecao => null()

  contains

    !Constructors
    procedure                       :: iniciar
    !Destructors
    procedure                       :: finalizar
    !Sets
    procedure                       :: defineId
    procedure                       :: defineChave
    procedure                       :: definePrimeiro
    procedure                       :: defineSeguinte
    !Gets
    procedure                       :: obterId
    procedure                       :: obterChave
    procedure                       :: obterPrimeiro
    procedure                       :: obterSeguinte
    !Has
    procedure                       :: temId
    procedure                       :: temChave
    procedure                       :: temPrimeiro
    procedure                       :: temSeguinte
    !C_Colecao methods
    procedure                       :: obterProprio
    procedure			    :: adicionarNodo
    procedure                       :: paraCada
    procedure                       :: obter
    procedure                       :: obterAnterior
    procedure                       :: obterUltimo
    procedure                       :: mostrarId
    procedure                       :: mostrarNodo
    procedure                       :: mostrar
    procedure                       :: remover
    procedure                       :: tamanho
    procedure                       :: redefineId
    procedure                       :: redefinePrimeiro
    procedure 			    :: existeChave
    procedure                       :: mostrarChave
    procedure                       :: procuraChave
    procedure			    :: adicionar !deferred, abstract interface
    procedure, nopass               :: alocarNodo  !deferred, abstract interface, nopass
    procedure, nopass               :: desalocarNodo  !deferred, abstract interface, nopass

    !Regra: Um metodo de "define", de "obter" e de "tem"
    !por cada tipo de colecao.

#ifdef _OBJECTO_
#undef _VALOR_
#define _VALOR_ _OBJECTO_
#include "C_Colecao.inc"
#endif

#ifdef _COLECAO_
#undef _VALOR_
#define _VALOR_ _COLECAO_
#include "C_Colecao.inc"
#endif

  end type C_Colecao

  !-------------end type C_Colecao-------------------------------------!

contains

  !----------------type-bound procedures of type C_Objecto--------------!

  function obterTipoObj(self) result(str)
    class(C_Objecto), intent(in)     :: self
    character(len=_OBJSTR_LENGTH)    :: str
    str = self%tipoObj
  end function obterTipoObj

  subroutine defineTipoObj(self, str)
    class(C_Objecto)                 :: self
    character(len=_OBJSTR_LENGTH)    :: str
    self%tipoObj = str
  end subroutine defineTipoObj

  subroutine mostrarTipoObj(self)
    class(C_Objecto)                    :: self
    character(len=_OBJSTR_LENGTH)       :: str
    str = self%obterTipoObj()
    write(*,*) 'Elemento do tipo ', trim( self%obterTipoObj() )
  end subroutine mostrarTipoObj

  !----------------end of type-bound procedures of type C_Objecto-------!

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

    write(*,*) 'Lista de factory_collection esvaziada.'
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

  !C_Colecao methods

  subroutine adicionarNodo(self, nodo, chave)

    class(C_Colecao)                                      :: self
    class(C_Colecao), pointer, intent(inout), optional    :: nodo
    character(len=_OBJSTR_LENGTH), optional		  :: chave
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

        write(*,*) 'Error in adicionarNodo: Passed argument points to null().'

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

  function paraCada(self, node) result(keepup)

    !Simulates 'for each <item> in <List> do %%% end do'
    !usage: do while ( Lista%paraCada (item) )
    !usage: %%%
    !usage: end do

    class(C_Colecao)                             :: self
    class(C_Colecao), pointer, intent(inout)     :: node
    logical                                      :: keepup    
    class(C_Colecao), pointer                    :: ptr, nodeZero => null()

    if ( .not. associated( node ) ) then

      call self%alocarNodo( nodeZero )
      call nodeZero%defineId(0)
      call self%obterPrimeiro( ptr )
      call nodeZero%definePrimeiro( ptr )
      call self%obterProprio( ptr )
      call nodeZero%defineSeguinte( ptr )
      node => nodeZero

    end if

    if ( node%temSeguinte() ) then
      call node%obterSeguinte(node)
      keepup = .true.
    else
      nullify( node )      
      keepup = .false.
    end if

    if ( associated( nodeZero ) ) then
      call self%desalocarNodo( nodeZero ) 
    end if

  end function paraCada

  subroutine obter(self, id, nodo)

    class(C_Colecao)                            :: self
    integer                                     :: id    
    class(C_Colecao), pointer, intent(out)      :: nodo

    call self%obterPrimeiro(nodo)

    do while ( nodo%obterId() .ne. id )
      if ( nodo%temSeguinte() ) then
        call nodo%obterSeguinte(nodo)
      else
        id = nodo%obterId()
        write(*,*) 'WARN 000: Nao se encontrou o nodo ', id, ' na colecao'
      end if
    end do

  end subroutine obter

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

  subroutine mostrarId(self)

    class(C_Colecao)          :: self
    class(C_Colecao), pointer :: ptr

    call self%obterAnterior(ptr)

    write(*,*) ' '
    if ( self%obterId() .eq. ptr%obterId() ) then
      write(*,*) 'O item e o fundador da lista de factory_collection.'
    else
      write(*,*) 'O item anterior tem numero ', ptr%obterId()
    end if

    write(*,*) 'O numero do item e o ', self%obterId()

    call self%obterSeguinte(ptr)

    if ( .not. self%temSeguinte() ) then
      write(*,*) 'O item e o ultimo da lista de factory_collection.'
    else
      write(*,*) 'O item seguinte tem numero', ptr%obterId()
    end if

  end subroutine mostrarId

  subroutine mostrarNodo(self)

    class(C_Colecao)          :: self

    call self%mostrarId()
    if ( self%temChave() ) then
      call self%mostrarChave()
    end if
#ifdef _OBJECTO_
    if ( self%temObjecto() ) then
      call self%objecto%mostrarTipoObj()
    end if
#endif
#ifdef _COLECAO_
    if ( self%temColecao() ) then
      call self%Colecao%mostrarTipoObj()
    end if
#endif

  end subroutine mostrarNodo

  subroutine mostrar(self)

    class(C_Colecao)          :: self
    class(C_Colecao), pointer :: item => null()

    do while ( self%paraCada(item) )
      call item%mostrarNodo()
    end do

    write(*,*) ''
    write(*,*) 'A lista contem ', self%tamanho(), ' elementos' 
    write(*,*) 'Lista de factory_collection mostrada.'
    write(*,*) ''

  end subroutine mostrar

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
#ifdef _OBJECTO_
      if ( ultimo%temObjecto() ) then
        deallocate( ultimo%Objecto )
      end if
#endif
#ifdef _COLECAO_
      if ( ultimo%temColecao() ) then
        deallocate( ultimo%Colecao )
      end if
#endif
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

  subroutine mostrarChave(self)
    class(C_Colecao)				:: self
    write(*,*) 'a chave é "', trim(self%obterChave()),'".'
  end subroutine mostrarChave

  subroutine procuraChave(self, chave, resultado)

    class(C_Colecao)				:: self
    character(len=_OBJSTR_LENGTH), intent(in)	:: chave
    class(C_Colecao), pointer, intent(inout)	:: resultado
    class(C_Colecao), pointer			:: item => null()
    
    nullify( resultado )
    do while ( self%paraCada( item ) )
      if ( trim(item%obterChave()) .eq. trim(chave) ) then
        call item%obterProprio( resultado )
        write(*,*) 'Found key "', trim(chave), '" in element with id', item%obterId()
        write(*,*) ' '
      end if
    end do

  end subroutine procuraChave

  !-------------------------Extensão C_Colecao ----------------------!

  subroutine adicionar(self, chave)

    class(C_Colecao)                                      :: self
    character(len=_OBJSTR_LENGTH), optional		  :: chave
    class(C_Colecao), pointer				  :: nodo => null()
#ifdef _OBJECTO_
    class(C_Objecto), pointer				  :: Objecto => null()
#endif
#ifdef _COLECAO_
    class(C_Colecao), pointer				  :: Colecao => null()
#endif

    if ( present( chave ) ) then
      call self%adicionarNodo( chave = chave )
    else
      call self%adicionarNodo()
    end if

    call self%obterUltimo( nodo )

#ifdef _OBJECTO_
    allocate( Objecto )
    call nodo%defineObjecto( Objecto )
    nullify( Objecto )
#endif
#ifdef _COLECAO_
    allocate( Colecao )
    call nodo%defineColecao( Colecao )
    nullify( Colecao )
#endif

  end subroutine adicionar

  subroutine alocarNodo( new ) !nopass
    class(C_Colecao), pointer, intent(inout)	:: new
    allocate( new )
  end subroutine alocarNodo

  subroutine desalocarNodo( ptr ) !nopass
    class(C_Colecao), pointer, intent(inout)	:: ptr
    if ( associated( ptr ) ) then
      deallocate( ptr )
      nullify( ptr )
    else
      write(*,*) 'Warning: desalocarNodo - argument already points to null.'
    endif
  end subroutine desalocarNodo

#ifdef _OBJECTO_
#undef  _VALOR_
#define _VALOR_ _OBJECTO_
#include "C_Colecao_contains.inc"
#endif

#ifdef _COLECAO_
#undef  _VALOR_
#define _VALOR_ _COLECAO_
#include "C_Colecao_contains.inc"
#endif

  !-----------end type-bound procedures type C_Colecao----------!

end module class_collection

!------------------ Program -----------------------------!

program unitTests_lista_colecao

  use class_collection

  implicit none

  integer                       :: i 
  type(C_Colecao)               :: lista
  class(C_Colecao), pointer     :: nodo => null()
  class(C_Objecto), pointer     :: item => null()
  character(len=_OBJSTR_LENGTH) :: achave = 'Olá'

  do i = 1, 2
    call lista%adicionarNodo()
    call lista%obterUltimo( nodo )
    allocate( item )
    call nodo%defineObjecto( item )
    nullify( item )
    nullify( nodo )
  end do

  call lista%adicionar( chave = achave )

  do i = 1, 2
    call lista%adicionar()
  end do

  call lista%mostrar()
  call lista%procuraChave( achave, nodo )
  call nodo%mostrarNodo()
  call lista%finalizar()
  call lista%mostrar()

  pause

end program unitTests_lista_colecao

