module class_collection

  use class_capsule

#ifndef _OBJSTR_LENGTH
#define _OBJSTR_LENGTH 128
#endif

  !Regra 1: When using classes in fortran 2003, try considering that 'target' 
  !is a forbidden directive, except in 'get', 'set' and 'has' methods.
  !Regra 2: Encapsular em procedures os usos de 'associated' com retorno
  !de resultado verdadeiro/falso.
  !Regra 3: Para cada campo num tipo, tem que haver um metodo "defineCampo"
  !e um metodo "obtemCampo", assim como um "temCampo" e um "mostraCampo".
  !Adicionalmente, se o campo for de tipo "pointer", convem haver um metodo "alocaCampo"
  !e um metodo "desalocaCampo".

  implicit none

  private

  !----------------type C_Colecao---------------------------------!

  type, public                     ::  C_Colecao

    private

    integer                        :: id = 0
    character(:), allocatable      :: chave
    class(C_Colecao),  pointer     :: fundador => null()
    class(C_Colecao),  pointer     :: seguinte => null()
    class(C_Capsula),  pointer     :: valor => null()

  contains

    !Constructors
    procedure                       :: inicializa
    !Destructors
    procedure                       :: finaliza
    !Sets
    procedure                       :: defineId
    procedure                       :: defineChave
    procedure                       :: defineValor
    procedure                       :: definePrimeiro
    procedure                       :: defineSeguinte
    !Gets
    procedure                       :: obtemId
    procedure                       :: obtemChave
    procedure                       :: obtemValor
    procedure                       :: obtemPrimeiro
    procedure                       :: obtemSeguinte
    !Has
    procedure                       :: temId
    procedure                       :: temChave
    procedure                       :: temValor
    procedure                       :: temPrimeiro
    procedure                       :: temSeguinte
    !Show
    procedure                       :: mostraId
    procedure                       :: mostraChave
    procedure                       :: mostraValor

    !C_Colecao methods
    procedure                       :: obtemProprio
    procedure                       :: obtemAnterior
    procedure                       :: obtemUltimo

    procedure                       :: mostra
    procedure                       :: mostraNodo

    procedure                       :: empilha
    procedure			                  :: empilhaPilha

    procedure                       :: paraCada
    procedure                       :: desempilha
    procedure, nopass               :: alocaNodo
    procedure, nopass               :: desalocaNodo
    procedure                       :: desalocaValor
    procedure                       :: tamanho
    procedure 			                :: existeChave

    procedure                       :: procura
    procedure                       :: procuraId
    procedure                       :: procuraChave

    procedure                       :: redefineId
    procedure                       :: redefinePrimeiro

  end type C_Colecao

  !-------------end type C_Colecao-------------------------------------!

contains

  !----------------type-bound procedures of type C_Colecao-------------!

  !Constructors

  subroutine inicializa(self, id)

    class(C_Colecao), intent(inout)    :: self
    integer, intent(in), optional      :: id
    class(C_Colecao), pointer          :: ptr

    if ( .not. self%temPrimeiro() ) then
      if ( present( id ) ) then
        call self%defineId( id )
      end if
      call self%obtemProprio( ptr )
      call self%definePrimeiro( ptr )
      nullify( ptr )
      call self%defineSeguinte( ptr )
      write(*,*) 'Criado item numero ', self%obtemId()
    end if

  end subroutine

  !Destructors

  subroutine finaliza(self)

    class(C_Colecao), intent(inout) :: self
    class(C_Colecao), pointer       :: first

    call self%obtemPrimeiro(first)

    do while ( first%temSeguinte() )
      call first%desempilha()
    end do

    write(*,*) 'Lista esvaziada.'
    write(*,*) ''

  end subroutine

  !Sets

  subroutine defineId(self, id)
    class(C_Colecao), intent(inout) :: self
    integer                         :: id
    self%id = id
  end subroutine

  subroutine defineChave(self, chave)
    class(C_Colecao), intent(inout) :: self
    character(len=*), intent(in)    :: chave
    if ( .not. self%existeChave(chave) ) then
      self%chave = trim(chave)
    else
      write(*,*) 'Error: defineChave - Chave already exists!'
    end if
  end subroutine 

  subroutine defineValor (self, valor)
    class(C_Colecao), intent(inout)       :: self
    class(C_Capsula), intent(in),pointer  :: valor
    self%valor => valor
  end subroutine 

  subroutine definePrimeiro(self, primeiro)
    class(C_Colecao), intent(inout)           :: self
    class(C_Colecao), intent(in), pointer     :: primeiro
    self%fundador => primeiro
  end subroutine

  subroutine defineSeguinte(self, seguinte)
    class(C_Colecao), intent(inout)           :: self
    class(C_Colecao), intent(in), pointer     :: seguinte
    self%seguinte => seguinte
  end subroutine

  !Gets
  !It is safer to avoid getting pointers on function returns
  !as they are not (yet as of ifort 12.0) usable directly
  !as arguments. To get pointers it's  best to use
  !subroutine calls.
  !Regra: devido a limitacao do ifort12.0, usar subroutines
  !para obtem apontadores. Pode-se usar functions (que é melhor)
  !para obtem escalares.

  subroutine obtemProprio(self, proprio)
    class(C_Colecao), target, intent(in)        :: self
    class(C_Colecao), pointer, intent(out)      :: proprio
    proprio => self
  end subroutine

  function obtemId(self) result(id)
    class(C_Colecao), intent(in)  :: self
    integer                       :: id
    id = self%id
  end function

  function obtemChave(self) result(chave)
    class(C_Colecao), intent(in)    :: self
    character(:), allocatable       :: chave
    chave = self%chave
  end function

  subroutine obtemValor (self, valor)
    class(C_Colecao), intent(in)            :: self
    class(C_Capsula), pointer, intent(out)  :: valor
    valor => self%valor
  end subroutine

  subroutine obtemPrimeiro(self, primeiro)
    class(C_Colecao)                          :: self
    class(C_Colecao), pointer, intent(out)    :: primeiro
    primeiro => self%fundador
  end subroutine

  subroutine obtemSeguinte(self, seguinte)

    class(C_Colecao), intent(in)            :: self
    class(C_Colecao), pointer, intent(out)  :: seguinte

    if ( self%temSeguinte() ) then
      seguinte => self%seguinte
    else
      nullify( seguinte )
    end if

  end subroutine

  !Has methods

  function temId(self) result(tem)

    class(C_Colecao), intent(in)  :: self
    logical                       :: tem

    if ( self%id .ne. 0 ) then
      tem = .true.
    else
      tem = .false.
    endif

  end function

  function temChave(self) result(tem)
    
    class(C_Colecao), intent(in)  :: self
    logical                       :: tem

    if ( trim(self%chave) .ne. "_" ) then
      tem = .true.
    else
      tem = .false.
    endif

  end function

  function temValor (self) result(tem)
      class(C_Colecao), intent(in)  :: self
      logical                       :: tem
      if ( associated(self%valor) ) then
        tem = .true.
      else
        tem = .false.
      endif
  end function

  function temPrimeiro(self) result(tem)
  
    class(C_Colecao), intent(in)  :: self
    logical                       :: tem

    if ( associated( self%fundador ) ) then
      tem = .true.
    else
      tem = .false.
    end if

  end function

  function temSeguinte(self) result(tem)

    class(C_Colecao), intent(in)   :: self
    logical                        :: tem

    if ( associated( self%seguinte ) ) then     
      tem = .true.
    else
      tem = .false.
    end if

  end function

  !Show
  subroutine mostraId(self)

    class(C_Colecao), intent(inout) :: self
    class(C_Colecao), pointer       :: ptr

    call self%obtemAnterior(ptr)

    write(*,*) ' '
    if ( self%obtemId() .eq. ptr%obtemId() ) then
      write(*,*) 'O item e o fundador da lista da colecao.'
    else
      write(*,*) 'O item anterior tem numero ', ptr%obtemId()
    end if

    write(*,*) 'O numero do item e o ', self%obtemId()

    call self%obtemSeguinte(ptr)

    if ( .not. self%temSeguinte() ) then
      write(*,*) 'O item e o ultimo da lista.'
    else
      write(*,*) 'O item seguinte tem numero', ptr%obtemId()
    end if

  end subroutine

  subroutine mostraChave(self)
    class(C_Colecao), intent(in)                :: self
    write(*,*) 'a chave é "', trim(self%obtemChave()),'".'
  end subroutine

  subroutine mostraValor (self)
    class(C_Colecao), intent(inout) :: self
    class(C_Capsula), pointer       :: valor
    call self%obtemValor( valor )
    call valor%mostra()
  end subroutine

  !C_Colecao methods

  subroutine mostraNodo(self)

    class(C_Colecao), intent(inout) :: self

    call self%mostraId()
    if ( self%temChave() ) then
      call self%mostraChave()
    end if
    if ( self%temValor() ) then
      call self%mostraValor()
    end if

  end subroutine

  subroutine mostra(self)

    class(C_Colecao), intent(inout)          :: self
    class(C_Colecao), pointer :: item => null()

    do while ( self%paraCada(item) )
      call item%mostraNodo()
    end do

    write(*,*) ''
    write(*,*) 'A lista contem ', self%tamanho(), ' elementos'
    write(*,*) 'Lista mostrada.'
    write(*,*) ''

  end subroutine

  subroutine empilha(self, valor, chave)

    class(C_Colecao), intent(inout)             :: self
    class(C_Capsula), intent(in), pointer       :: valor
    character(len=*), intent(in), optional      :: chave
    class(C_Colecao), pointer                   :: nodo => null()

    if ( present( chave ) ) then
      call self%empilhaPilha( chave = chave )
    else
      call self%empilhaPilha()
    end if

    call self%obtemUltimo( nodo )
    if ( associated( valor ) ) then
      call nodo%defineValor( valor )
    else
      write(*,*) 'Erro: a capsula a empilha na pilha aponta para null()'
    end if

  end subroutine

  subroutine empilhaPilha(self, nodo, chave)

    class(C_Colecao), intent(inout)                       :: self
    class(C_Colecao), pointer, intent(inout), optional    :: nodo
    character(len=*), optional, intent(in)                :: chave
    class(C_Colecao), pointer                             :: ultimo, new => null(), primeiro

    if ( present( nodo ) ) then

      if ( associated( nodo ) ) then

        !'ptr' pode ser um simples nodo de colecao
        ! mas tambem pode representar uma colecao
        ! inteira.
        ! É sempre necessário redefinir o fundador
        ! e redefineIdr os ids.

        if ( .not. nodo%temPrimeiro() ) then
          call nodo%inicializa( 1 )
        endif

        if ( .not. self%temPrimeiro() ) then
          call self%definePrimeiro( nodo )
        else 
          call self%obtemUltimo( ultimo )
          call ultimo%defineSeguinte( nodo )
          call self%obtemPrimeiro( primeiro )
          call self%redefinePrimeiro( primeiro )
          call self%redefineId()
        endif
        
        call self%obtemUltimo( ultimo )
        
        if ( nodo%obtemId() .ne. ultimo%obtemId() ) then
          write(*,*) 'Inserido item numero ', nodo%obtemId() &
                   , ' até ', ultimo%obtemId()
        else
          write(*,*) 'Inserido item numero ', nodo%obtemId()
        end if

        if ( present( chave ) ) then
          call nodo%defineChave(chave)
        end if

      else

        write(*,*) 'Error in empilhaPilha: Passed argument points to null().'

      endif

    else

      if ( .not. self%temPrimeiro() ) then

        call self%inicializa( 1 )

      else   

        call self%obtemPrimeiro(primeiro)
        call self%obtemUltimo(ultimo)
        call self%alocaNodo( new )
        call new%defineId( ultimo%obtemId() + 1 )
        call new%definePrimeiro( primeiro )
        call ultimo%defineSeguinte( new )
        if ( present( chave ) ) then
	        call new%defineChave(chave)
	      end if
        write(*,*) 'Criado item numero ', new%obtemId()
    
      end if

    end if

  end subroutine empilhaPilha

  function paraCada(self, node, valor) result(keepup)

    !Simulates 'for each <item> in <List> do %%% end do'
    !usage: do while ( Lista%paraCada (item) )
    !usage: %%%
    !usage: end do

    class(C_Colecao), intent(inout)             	:: self
    class(C_Colecao), pointer, intent(inout)     	:: node
    class(C_Capsula), pointer, optional, intent(out)	:: valor
    logical                                      	:: keepup    
    class(C_Colecao), pointer                    	:: ptr, nodeZero => null()

    if ( .not. associated( node ) ) then

      call self%alocaNodo( nodeZero )
      call nodeZero%defineId(0)
      call self%obtemPrimeiro( ptr )
      call nodeZero%definePrimeiro( ptr )
!      call self%obtemProprio( ptr )
      call nodeZero%defineSeguinte( ptr )
      node => nodeZero

    end if

    if ( node%temSeguinte() ) then
      call node%obtemSeguinte( node )
      if ( present( valor ) ) call node%obtemValor( valor )
      keepup = .true.
    else
      nullify( node )
      if ( present( valor ) ) nullify( valor )
      keepup = .false.
    end if

    if ( associated( nodeZero ) ) then
      call self%desalocaNodo( nodeZero ) 
    end if

  end function paraCada

  function procuraId(self, id, nodo) result(found)
    class(C_Colecao), intent(inout)             :: self
    integer, intent(in)                         :: id
    class(C_Colecao), pointer, intent(out)      :: nodo
    logical					:: found
    class(C_Colecao), pointer		        :: item => null()
    found = .false.
    if ( id .le. self%tamanho() ) then
      do while ( self%paraCada(item) )
        if ( item%obtemId() .eq. id ) then
	  found = .true.
          call item%obtemProprio( nodo )
	  write(*,*) ' '
	  write(*,*) 'Encontrado o elemento da colecao com id ', id
        end if
      end do
    else
      write(*,*) 'O id', id,'que procura é superior ao tamanho da coleção', self%tamanho()
      nullify( nodo )
    end if
  end function

  subroutine obtemAnterior(self, anterior)

    class(C_Colecao), intent(inout)             :: self
    class(C_Colecao), pointer, intent(out)      :: anterior
    class(C_Colecao), pointer                   :: seguinte

    call self%obtemPrimeiro(anterior)

    if ( self%obtemId() .ne. anterior%obtemId() ) then

      call anterior%obtemSeguinte(seguinte)

      do while ( seguinte%obtemId() .ne. self%obtemId() )
        if ( seguinte%temSeguinte() ) then
          call anterior%obtemSeguinte(anterior)
          call seguinte%obtemSeguinte(seguinte)
        else
          write(*,*) 'WARN 001: Nao foi encontrado o nodo anterior na colecao'
          write(*,*) 'C_Colecao corrompida.'
          exit          
        endif
      end do

    endif

  end subroutine

  subroutine obtemUltimo(self, ultimo)

    class(C_Colecao), intent(inout)               :: self
    class(C_Colecao), pointer, intent(inout)      :: ultimo

    call self%obtemPrimeiro(ultimo)

    do while ( ultimo%temSeguinte() )
      call ultimo%obtemSeguinte(ultimo)
    end do

  end subroutine


  subroutine desempilha(self)

    class(C_Colecao), intent(inout)   :: self
    class(C_Colecao), pointer         :: ultimo, penultimo, ptr

    call self%obtemUltimo(ultimo)
    call ultimo%obtemAnterior(penultimo)

    if ( ultimo%obtemId() .eq. penultimo%obtemId() ) then
      write(*,*) 'WARN: A lista contem apenas o seu elemento fundador.'
      write(*,*) 'Não se remove o elemento fundador da lista.'
      write(*,*) 'O elemento fundador so pode ser removido externamente.'
    else
      if ( ultimo%temValor() ) then
        call ultimo%desalocaValor()
      end if
      write(*,*) 'Removido item numero ', ultimo%obtemId()
      call self%desalocaNodo( ultimo )
    endif

    nullify( ptr )
    call penultimo%defineSeguinte( ptr )

  end subroutine

  subroutine desalocaValor( self )
    class(C_Colecao), intent(inout) :: self
    class(C_Capsula), pointer       :: valor
    if ( self%temValor() ) then
      call self%obtemValor( valor )
      call valor%limpaCapsula()
      deallocate( valor )
      nullify( self%valor )
    end if
  end subroutine

  function tamanho(self) result(tam)

    class(C_Colecao), intent(inout)   :: self
    integer                           :: tam
    class(C_Colecao), pointer         :: item => null()

    tam = 0

    do while ( self%paraCada(item) )
      tam = tam + 1 
    enddo

  end function

  subroutine redefineId(self)

    class(C_Colecao), intent(inout) :: self
    class(C_Colecao), pointer       :: item => null()
    integer                         :: i

    i = 1
    do while ( self%paraCada( item ) )
      call item%defineId( i )
      i = i + 1
    end do

  end subroutine

  subroutine redefinePrimeiro( self, primeiro )

    class(C_Colecao), intent(inout)               :: self
    class(C_Colecao), pointer, intent(in)         :: primeiro
    class(C_Colecao), pointer                     :: item => null()

    if ( associated( primeiro ) ) then
      do while ( self%paraCada( item ) )
        call item%definePrimeiro( primeiro ) 
      end do
    else
      write(*,*) 'Error: redefinePrimeiro, passed argument points to null.'
    end if

  end subroutine

  function existeChave(self, chave) result(existe)

    class(C_Colecao), intent(inout)   :: self
    character(len=*),intent(in)       :: chave
    logical                           :: existe
    class(C_Colecao), pointer         :: item => null()

    existe = .false.
    do while ( self%paraCada( item ) )
      if ( trim(item%chave) .eq. trim(chave) ) then
        existe = .true.
      end if
    end do

  end function

  function procuraChave(self, chave, resultado) result(found)

    class(C_Colecao), intent(inout)             :: self
    character(len=*), intent(in)	              :: chave
    class(C_Colecao), pointer, intent(inout)	  :: resultado
    logical					                            :: found
    class(C_Colecao), pointer                   :: item => null()
    
    found = .false.
    nullify( resultado )
    do while ( self%paraCada( item ) )
      if ( trim(item%obtemChave()) .eq. trim(chave) ) then
	found = .true.
        call item%obtemProprio( resultado )
        write(*,*) ' '
        write(*,*) 'Encontrada chave "', trim(chave), '" no elemento com id', item%obtemId()
      end if
    end do

  end function

  subroutine alocaNodo ( ptr ) !nopass
    class(C_Colecao), pointer, intent(inout)	:: ptr
    if ( associated( ptr ) ) then
      nullify( ptr )
      write(*,*) 'Warning: alocaNodo - argument is already associated. Nullifying ...'
    end if
    allocate( ptr )
  end subroutine

  subroutine desalocaNodo ( ptr ) !nopass
    class(C_Colecao), pointer, intent(inout)	:: ptr
    if ( associated( ptr ) ) then
      deallocate( ptr )
      nullify( ptr )
    else
      write(*,*) 'Warning: desalocaNodo - argument already points to null.'
    endif
  end subroutine

  function procura(self, resultado, valor, id, chave) result(found)
    class(C_Colecao), intent(inout)                     :: self
    class(C_Colecao), pointer, intent(out)      	      :: resultado
    class(C_Capsula), pointer, intent(out), optional    :: valor
    integer, optional, intent(in)                       ::  id
    character(len=*), optional, intent(in)              :: chave
    logical                                             :: found
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
        call resultado%obtemValor( valor )
      else
        nullify( valor )
      endif
    endif
  end function

  !-----------end type-bound procedures type C_Colecao----------!

end module class_collection

!------------------ Program -----------------------------!

program unitTests_lista_colecao

  use class_capsule
  use class_collection

  implicit none

  !Regra: as variáveis de type são da classe extendida
  !mas as variáveis apontadores de classe são da classe abstracta

  type(C_Colecao)                   :: caixa
  class(C_Colecao), pointer         :: nodo => null( )
  class(C_Capsula), pointer         :: capsula => null( )
  class(C_Maca), pointer            :: maca => null( )
  class(C_Objecto), pointer         :: objecto => null( )
  integer                           :: i

  !Programa que demonstra as features da classe C_Colecao
  !programada no standard Fortran2003.
  !A classe C_Colecao permite agrupar elementos dum tipo derivado
  !da classe C_Objecto numa pilha com indentificativo crescente 
  !começando em 1.
  !Os metodos mais usuais dessa colecao são
  ! - empilha novos nodos à colecao ( no fim --> LIFO )
  ! - procura por um nodo por identificativo ou por chave
  ! - extrair o objecto dum nodo
  ! - mostra toda a colecao ou mostra um nodo da colecao
  ! - desempilha um nodo ( o ultimo --> LIFO )
  ! - desempilha todos os elementos da colecao menos o primeiro

  !Cria e adiciona 2 elementos que guarda na colecao
  do i = 1, 2
    !maca -> intent(in), capsula -> intent(out)
    call encapsula( maca, capsula )
    call caixa%empilha( capsula )
  end do

  !Cria e adiciona 1 elemento com uma chave associada.
  call encapsula( maca, capsula )
  call caixa%empilha( capsula, chave = 'Maçã especial' )

  !Procura o elemento da colecao contendo aquela chave
  !e mostra elemento
  if ( caixa%procura( nodo, chave = 'Maçã especial' ) ) then
    call nodo%mostraNodo( )
  end if

  !Procura o elemento número 2 da lista,
  !extrai o valor e mostra
  if ( caixa%procura( nodo, id = 2 ) ) then
    call nodo%obtemValor( capsula )
    if ( desencapsula( capsula, maca ) ) call maca%mostraCategoria( )
  end if

  !Igual ao anterior: procura, extrai valor e mostra
  if ( caixa%procura( nodo, valor = capsula, id = 1 ) ) then
    if ( desencapsula( capsula, maca ) ) call maca%mostraCategoria( )
  end if

  !Encapsula um novo outro tipo de objecto numa nova capsula e empilha na mesma caixa
  call encapsula( objecto, capsula )
  call caixa%empilha( capsula, chave = 'Determinado e particular objecto' )

  !Mostra toda a colecao de objectos
  call caixa%mostra( )

  !Faz a mesma coisa mas
  !utiliza o ciclo "for each" da colecao.
  nullify( nodo )
  do while( caixa%paraCada( nodo ) )
    call nodo%mostraNodo( )
  enddo

  !Semelhante ao "for each" anterior
  !mas extrai o valor e mostra
  nullify( nodo )
  do while( caixa%paraCada( nodo, valor = capsula ) )
    if ( desencapsula( capsula, maca ) ) call maca%mostraCategoria()    
    if ( desencapsula( capsula, objecto ) ) call objecto%mostraTipoObj()    
  enddo
 
  !Remove todos os itens da colecao
  !(excepto o item fundador da colecao)
  call caixa%finaliza( )

  !Mostra o item fundador da colecao
  call caixa%mostra( )

  pause

end program unitTests_lista_colecao

