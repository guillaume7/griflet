module class_capsule

  !use class_something

#ifndef _OBJSTR_LENGTH
#define _OBJSTR_LENGTH 128
#endif

  implicit none

  private

 ! Os tipos Objecto e Maca são exemplos de objectos que podem
 ! encapsulados e colocados numa pilha (C_Colecao).

 !----------------------class C_Objecto------------------------------!

 ! Regra 1: Cada variável derivada do tipo C_Objecto tem que ter
 ! o campo tipoObj inicializado com o nome do tipo.
  type, public :: C_Objecto
    !character(:), allocatable          :: tipoObj = "C_Objecto"
    character(:), allocatable           :: tipoObj
  contains
    procedure                           :: defineTipoObj
    procedure                           :: obtemTipoObj
    procedure                           :: mostraTipoObj
  end type

  !----------------end class C_Objecto------------------------------!

  !----------------class C_Maca------------------------------!

  type, public, extends(C_Objecto)      :: C_Maca
    !character(:), allocatable       :: categoria = "Categoria Indefinida"
    character(:), allocatable           :: categoria
  contains
    procedure                           :: defineCategoria
    procedure                           :: obtemCategoria
    procedure                           :: temCategoria
    procedure                           :: mostraCategoria
  end type

  !-------------end class C_Maca-----------------------------!

  ! Os tipos C_Capsula e C_Colecao sao os tipos importantes
  ! deste modulo.

  !----------------class C_Capsula------------------------------!

  type, public                            :: C_Capsula

    !character(:), allocatable       :: genero = "indefinido"
    character(:), allocatable             :: genero
    
    class(C_Objecto), pointer             :: Objecto =>   null()
    class(C_Maca), pointer                :: Maca =>      null()
    !class(C_Something), pointer	:: Something =>     null()

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
    procedure                             :: limpaGenero

    !metodos que abrangem todos os generos
    procedure                             :: limpaCapsula
    procedure                             :: mostraCapsula

  end type

  public :: encapsula
  interface encapsula
    module procedure encapsulaObjecto
    module procedure encapsulaMaca
    !module procedure encapsulaSomething
  end interface

  public :: reencapsula
  interface reencapsula
    module procedure reencapsulaObjecto
    module procedure reencapsulaMaca
    !module procedure reencapsulaSomething
  end interface

  public :: desencapsula
  interface desencapsula
    module procedure desencapsulaObjecto
    module procedure desencapsulaMaca
    !module procedure desencapsulaSomething
  end interface

  !-------------end class C_Capsula-----------------------------!

contains

  !----------------class-bound procedures of class C_Objecto--------------!

  subroutine defineTipoObj(this, str)
    class(C_Objecto), intent(inout)   :: this
    character(len=*), intent(in)      :: str
    this%tipoObj = str
  end subroutine

  function obtemTipoObj(this) result(str)
    class(C_Objecto), intent(in)      :: this
    character(:), allocatable         :: str
    str = this%tipoObj
  end function

  subroutine mostraTipoObj(this)
    class(C_Objecto), intent(in)      :: this
    character(:), allocatable         :: str
    str = this%obtemTipoObj()
    write(*,*) 'Elemento do tipo ', trim( this%obtemTipoObj() )
  end subroutine

  !----------------end of class-bound procedures of class C_Objecto-------!

  !----------class-bound procedures of class C_Maca---------------!

  subroutine defineCategoria(this, tipo)
    class(C_Maca), intent(inout)    :: this
    integer, intent(in)             :: tipo
    if ( tipo .eq. 1 ) then
      this%categoria = "Starking"
    elseif ( tipo .eq. 2 ) then
      this%categoria = "Golden"
    elseif ( tipo .eq. 3 ) then
      this%categoria = "Reinette"
    else
      this%categoria = "Appleseed"
    endif
  end subroutine

  function obtemCategoria(this) result(acategoria)
    class(C_Maca), intent(in)   :: this
    character(:), allocatable   :: acategoria
    acategoria = this%categoria
  end function

  function temCategoria(this) result(tem)
    class(C_Maca), intent(in)       :: this
    logical                         :: tem
    if ( this%categoria .eq. "Categoria Indefinida" ) then
      tem = .false.
    else
      tem = .true.
    end if
  end function

  subroutine mostraCategoria(this)
    class(C_Maca), intent(in)      :: this
    write(*,*) 'Maca de categoria ', trim( this%obtemCategoria() )
  end subroutine

  !----------end class-bound procedures of class C_Maca-----------!

  !----------class-bound and pointer procedures of class C_Capsula------------!

  subroutine defineGenero( this, strgenero )
    class(C_Capsula), intent(inout)     :: this
    character(len=*), intent(in)        :: strgenero
    select case ( strgenero )
      case ('Objecto')
        this%tem        => temObjecto
        this%aloca      => alocaObjecto
        this%desaloca   => desalocaObjecto
        this%mostra     => mostraObjecto
      case ('Maca')
        this%tem        => temMaca
        this%aloca      => alocaMaca
        this%desaloca   => desalocaMaca
        this%mostra     => mostraMaca
      !case ('Something')
      !  this%tem        => temSomething
      !  this%aloca      => alocaSomething
      !  this%desaloca   => desalocaSomething
      !  this%mostra     => mostraSomething
      case default
        nullify( this%tem )
        nullify( this%aloca )
        nullify( this%desaloca )
        nullify( this%mostra )
    end select
    this%genero = strgenero
  end subroutine

  function obtemGenero( this ) result( strgenero )
    class(C_Capsula), intent(in)         :: this
    character(:), allocatable           :: strgenero
    strgenero = this%genero
  end function

  function temGenero( this ) result(tem)
    class(C_Capsula), intent(in)        :: this
    logical                             :: tem
    character(:), allocatable           :: strgenero
    strgenero = this%obtemGenero( )
    if ( trim(strgenero) .eq. 'indefinido' ) then
      tem = .false.
    else
      tem = .true.
    end if
  end function

  subroutine mostraGenero( this, strgenero )
    class(C_Capsula), intent(inout)         :: this
    character(len=*), intent(in), optional  :: strgenero
    character(:), allocatable               :: origenero
    origenero = this%obtemGenero( )
    if ( present( strgenero ) ) then
      call this%defineGenero( strgenero )
      if ( associated ( this%mostra ) ) call this%mostra()
      call this%defineGenero( origenero )
    else
        write(*,*) 'O presente genero da capsula e ', trim( origenero )        
    end if
  end subroutine

  subroutine limpaGenero( this, strgenero )
    class(C_Capsula), intent(inout) :: this
    character(len=*), intent(in)    :: strgenero
    character(:), allocatable       :: stroriginal
    stroriginal = this%obtemGenero( )
    call this%defineGenero( strgenero )
    if ( associated ( this%tem ) ) then
      if ( this%tem() ) call this%desaloca()
    end if
    call this%defineGenero( stroriginal )
  end subroutine

  subroutine limpaCapsula ( this )
    class(C_Capsula), intent(inout)    :: this
    call this%limpaGenero( 'Objecto' )
    call this%limpaGenero( 'Maca' )
    !call this%limpaGenero( 'Something') )
    call this%limpaGenero( 'Indefinido' )
  end subroutine

  subroutine mostraCapsula ( this )
    class(C_Capsula), intent(inout)   :: this
    call this%mostraGenero( 'Objecto' )
    call this%mostraGenero( 'Maca' )
    !call this%mostraGenero( 'Something' )
    call this%mostraGenero( 'Indefinido' )
  end subroutine

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

end module class_capsule

!------------------ Program -----------------------------!

#ifndef _MODULE_
program unitTests_capsula

  use class_capsule

  implicit none

  !Regra: as variáveis de class são da classe extendida
  !mas as variáveis apontadores de classe são da classe abstracta

  class(C_Capsula), pointer         :: capsula => null()
  !type(C_Capsula)                  :: capsula
  class(C_Maca), pointer            :: maca => null()
  class(C_Objecto), pointer         :: objecto => null()
  integer                           :: i

  !conceito: aloca uma nova maca dentro duma nova capsula
  call encapsula( maca, capsula )
  !capsula = encapsula( maca )

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
  !capsula = encapsula( maca )

  !conceito: desaloca a maca da capsula e aloca uma nova maca dentro da mesma capsula
  call reencapsula( maca, capsula )

  !conceito: desaloca a maca da capsula e insere a nova maca dentro da mesma capsula
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
