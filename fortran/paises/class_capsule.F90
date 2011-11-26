module class_capsule

  !AQUI
  !use class_something

#ifndef _OBJSTR_LENGTH
#define _OBJSTR_LENGTH 128
#endif

! TODO:
!       encapsula
!       desencapsula
!       reencapsula

  implicit none

  private

 ! Os tipos Objecto e Maca são exemplos de objectos que podem
 ! encapsulados e colocados numa pilha (C_Colecao).

 !----------------------class C_Objecto------------------------------!

 ! Regra 1: Cada variável derivada do tipo C_Objecto tem que ter
 ! o campo tipoObj inicializado com o nome do tipo.
  type, public :: C_Objecto
    character(len=_OBJSTR_LENGTH)       :: tipoObj = "C_Objecto"
  contains
    procedure                           :: defineTipoObj
    procedure                           :: obtemTipoObj
    procedure                           :: mostraTipoObj
  end type C_Objecto

  !----------------end class C_Objecto------------------------------!

  !----------------class C_Maca------------------------------!

  type, public, extends(C_Objecto)      :: C_Maca
    character(len=_OBJSTR_LENGTH)       :: categoria = "Categoria Indefinida"
  contains
    procedure                           :: defineCategoria
    procedure                           :: obtemCategoria
    procedure                           :: temCategoria
    procedure                           :: mostraCategoria
  end type C_Maca

  !-------------end class C_Maca-----------------------------!

  ! Os tipos C_Capsula e C_Colecao sao os tipos importantes
  ! deste modulo.

  !----------------class C_Capsula------------------------------!

  type, public                          :: C_Capsula

    character(len=_OBJSTR_LENGTH)       :: genero = "indefinido"
    
    !AQUI
    class(C_Objecto), pointer           :: Objecto => null()
    class(C_Maca), pointer              :: Maca => null()
    !class(C_Something), pointer	:: Something => null()

    !métodos que apontam para um genero de tipo ou de classe
    procedure(alocaObjecto), pointer      :: aloca
    procedure(desalocaObjecto), pointer   :: desaloca
    procedure(temObjecto), pointer        :: tem
    procedure(mostraObjecto), pointer     :: mostra

  contains

    !metodos do identificativo do genero
    procedure                             :: defineGenero
    procedure                             :: obtemGenero
    procedure                             :: temGenero
    procedure                             :: mostraGenero
    procedure				  :: limpaGenero

    !metodos que abrangem todos os generos
    procedure                             :: limpaCapsula
    procedure                             :: mostraCapsula

  end type C_Capsula

  !AQUI
  public :: encapsula
  interface encapsula
    module procedure encapsulaObjecto
    module procedure encapsulaMaca
    !module procedure encapsulaSomething
  end interface encapsula

  !AQUI
  public :: reencapsula
  interface reencapsula
    module procedure reencapsulaObjecto
    module procedure reencapsulaMaca
    !module procedure reencapsulaSomething
  end interface reencapsula

  !AQUI
  public :: desencapsula
  interface desencapsula
    module procedure desencapsulaObjecto
    module procedure desencapsulaMaca
    !module procedure desencapsulaSomething
  end interface desencapsula

  !-------------end class C_Capsula-----------------------------!

  public                :: str

contains

  !----------------class-bound procedures of class C_Objecto--------------!

  subroutine defineTipoObj(self, str)
    class(C_Objecto)                 :: self
    character(len=_OBJSTR_LENGTH)    :: str
    self%tipoObj = str
  end subroutine defineTipoObj

  function obtemTipoObj(self) result(str)
    class(C_Objecto), intent(in)     :: self
    character(len=_OBJSTR_LENGTH)    :: str
    str = self%tipoObj
  end function obtemTipoObj

  subroutine mostraTipoObj(self)
    class(C_Objecto)                    :: self
    character(len=_OBJSTR_LENGTH)       :: str
    str = self%obtemTipoObj()
    write(*,*) 'Elemento do tipo ', trim( self%obtemTipoObj() )
  end subroutine mostraTipoObj

  !----------------end of class-bound procedures of class C_Objecto-------!

  !----------class-bound procedures of class C_Maca---------------!

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

  function obtemCategoria(self) result(acategoria)
    class(C_Maca)                   :: self
    character(len=_OBJSTR_LENGTH)   :: acategoria
    acategoria = self%categoria
  end function obtemCategoria

  function temCategoria(self) result(tem)
    class(C_Maca)                   :: self
    logical                         :: tem
    if ( self%categoria .eq. "Categoria Indefinida" ) then
      tem = .false.
    else
      tem = .true.
    end if
  end function temCategoria

  subroutine mostraCategoria(self)
    class(C_Maca)                   :: self
    write(*,*) 'Maca de categoria ', trim( self%obtemCategoria() )
  end subroutine mostraCategoria

  !----------end class-bound procedures of class C_Maca-----------!

  !----------class-bound and pointer procedures of class C_Capsula------------!

  !AQUI
  subroutine defineGenero( self, strgenero )
    class(C_Capsula)                    :: self
    character(len=_OBJSTR_LENGTH)       :: strgenero
    select case ( strgenero )
      case ('Objecto')
        self%tem        => temObjecto
        self%aloca      => alocaObjecto
        self%desaloca   => desalocaObjecto
        self%mostra     => mostraObjecto
      case ('Maca')
        self%tem        => temMaca
        self%aloca      => alocaMaca
        self%desaloca   => desalocaMaca
        self%mostra     => mostraMaca
      !case ('Something')
      !  self%tem        => temSomething
      !  self%aloca      => alocaSomething
      !  self%desaloca   => desalocaSomething
      !  self%mostra     => mostraSomething
      case default
        nullify( self%tem )
        nullify( self%aloca )
        nullify( self%desaloca )
        nullify( self%mostra )
    end select
    self%genero = strgenero
  end subroutine defineGenero

  subroutine obtemGenero( self, strgenero )
    class(C_Capsula)                    :: self
    character(len=_OBJSTR_LENGTH)       :: strgenero
    strgenero = self%genero
  end subroutine obtemGenero

  function temGenero( self ) result(tem)
    class(C_Capsula)                    :: self
    logical                             :: tem
    character(len=_OBJSTR_LENGTH)       :: strgenero
    call self%obtemGenero( strgenero )
    if ( trim(strgenero) .eq. 'indefinido' ) then
      tem = .false.
    else
      tem = .true.
    end if
  end function temGenero

  subroutine mostraGenero( self, strgenero )
    class(C_Capsula)                    	:: self
    character(len=_OBJSTR_LENGTH), optional     :: strgenero
    character(len=_OBJSTR_LENGTH)		:: origenero
    call self%obtemGenero( origenero )
    if ( present(strgenero) ) then
      call self%defineGenero( strgenero )
      if ( associated ( self%mostra ) ) call self%mostra()
      call self%defineGenero( origenero )
    else
        write(*,*) 'O presente genero da capsula e ', trim(origenero)
    end if
  end subroutine mostraGenero

  subroutine limpaGenero( self, strgenero )
    class(C_Capsula)			:: self
    character(len=_OBJSTR_LENGTH)	:: strgenero
    character(len=_OBJSTR_LENGTH)	:: stroriginal
    call self%obtemGenero( stroriginal )
    call self%defineGenero( strgenero )
    if ( associated ( self%tem ) ) then
      if ( self%tem() ) call self%desaloca()
    end if
    call self%defineGenero( stroriginal )
  end subroutine limpaGenero

  !AQUI
  subroutine limpaCapsula ( self )
    class(C_Capsula)			:: self
    call self%limpaGenero( Str('Objecto') )
    call self%limpaGenero( Str('Maca') )
    !call self%limpaGenero( Str('Something') )
    call self%limpaGenero( Str('Indefinido') )
  end subroutine limpaCapsula

  !AQUI
  subroutine mostraCapsula ( self )
    class(C_Capsula)			:: self
    call self%mostraGenero( Str('Objecto') )
    call self%mostraGenero( Str('Maca') )
    !call self%mostraGenero( Str('Something') )
    call self%mostraGenero( Str('Indefinido') )
  end subroutine mostraCapsula  

!AQUI
#undef _VALOR_
#define _VALOR_ Objecto
#include "C_Capsula_contains.inc"

#undef _VALOR_
#define _VALOR_ Maca
#include "C_Capsula_contains.inc"

!#undef _VALOR_
!#define _VALOR_ Something
!#include "C_Capsula_contains.inc"

  !-----end class-bound and pointer procedures of class C_Capsula--------!

  function str(inStr) result(sizedStr)
    character(len=*), intent(in)        :: inStr
    character(len=_OBJSTR_LENGTH)       :: sizedStr
    sizedStr = trim(inStr)
  end function str

end module class_capsule

!------------------ Program -----------------------------!

#ifndef _MODULE_
program unitTests_capsula

  use class_capsule

  implicit none

  !Regra: as variáveis de class são da classe extendida
  !mas as variáveis apontadores de classe são da classe abstracta

  class(C_Capsula), pointer         :: capsula => null()
  class(C_Maca), pointer            :: maca => null()
  class(C_Objecto), pointer         :: objecto => null()
  integer                           :: i

  !conceito: aloca uma nova maca dentro duma nova capsula
  call encapsula( maca, capsula )

  !conceito: retorna o presente genero da capsula
  !resposta: 'Maca'
  call capsula%mostraGenero()

  if ( desencapsula( capsula, maca ) ) call maca%mostraCategoria()

  !conceito: desaloca a maca da capsula e desaloca a capsula
  call capsula%desaloca()
  deallocate ( capsula )
  nullify( capsula )

  !Assim que o apontador para maca for utilizado, e melhor
  !nulificar. Sobretudo se foi alocado de dentro da classe capsula.
  nullify( maca )
  !conceito: aloca uma nova maca dentro duma nova capsula
  !e muda o genero da capsula para 'maca'
  call encapsula( maca, capsula )

  !conceito: desaloca a maca e aloca uma nova maca dentro da mesma capsula
  call reencapsula( maca, capsula )

  !conceito: desaloca a maca e insere a nova maca dentro da mesma capsula
  allocate( maca )
  call reencapsula( maca, capsula )
  nullify( maca )

  !conceito: aloca um novo objecto dentro da mesma capsula
  !e muda o genero da capsula para 'objecto'
  call reencapsula( objecto, capsula )

  !conceito: mostra o conteudo da capsula
  !preservando o genero actual ('objecto')
  call capsula%mostraCapsula()

  !conceito: desencapsula e mostra a maca e o objecto
  !mudando o genero da capsula em conformidade em caso de sucesso
  if ( desencapsula( capsula, maca ) ) call maca%mostraCategoria()
  if ( desencapsula( capsula, objecto ) ) call objecto%mostraTipoObj()

  !conceito: limpa a capsula do seu conteudo
  !e muda o seu genero para 'indefinido'
  call capsula%limpaCapsula()

  pause

end program unitTests_capsula
#endif
