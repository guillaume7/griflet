#ifndef _VALOR_
#define _VALOR_ Objecto
#endif

#ifndef _PRESCAN_
#define _PRESCAN_
#define AFTERDEF(x) define ## x
#define DEFCAPSULA(x) AFTERDEF(x)
#define AFTEROBT(x) obtem ## x
#define OBTCAPSULA(x) AFTEROBT(x)
#define AFTERTEM(x) tem ## x
#define TEMCAPSULA(x) AFTERTEM(x)
#define AFTERMOS(x) mostra ## x
#define MOSCAPSULA(x) AFTERMOS(x)
#define AFTERSELF(x) self% ## x
#define SELFCAPSULA(x) AFTERSELF(x)
#define AFTERALO(x) aloca ## x
#define ALOCAPSULA(x) AFTERALO(x)
#define AFTERDES(x) desaloca ## x
#define DESCAPSULA(x) AFTERDES(x)
#define AFTEREN(x) encapsula ## x
#define ENCAPSULA(x) AFTEREN(x)
#define AFTERRE(x) reencapsula ## x
#define RECAPSULA(x) AFTERRE(x)
#define AFTERDE(x) desencapsula ## x
#define DECAPSULA(x) AFTERDE(x)
#define AFTERC(x) C_ ## x
#define CVALOR(x) AFTERC(x)
#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)
#endif

!----------------type-bound procedures of type C_Capsula-------------!

  subroutine DEFCAPSULA(_VALOR_) (self, valor)
    class(C_Capsula)								:: self
    type(CVALOR(_VALOR_)),pointer, intent(in)		:: valor
    SELFCAPSULA(_VALOR_) => valor
  end subroutine DEFCAPSULA(_VALOR_)
  
  subroutine OBTCAPSULA(_VALOR_) (self, valor)
    class(C_Capsula)					:: self
    type(CVALOR(_VALOR_)), pointer, intent(out)		:: valor
    if ( self%tem() ) then
      valor => SELFCAPSULA(_VALOR_)
    else
      nullify( valor )
    end if	
  end subroutine OBTCAPSULA(_VALOR_)

  function TEMCAPSULA(_VALOR_) (self) result(tem)
    class(C_Capsula)					:: self
    logical						:: tem
    if ( associated( SELFCAPSULA(_VALOR_) ) ) then
      tem = .true.
    else
      tem = .false.
    end if
  end function TEMCAPSULA(_VALOR_)
  
  subroutine MOSCAPSULA(_VALOR_) (self)
    class(C_Capsula)					:: self
    if ( self%tem() ) then
      write(*,*) 'O valor é do tipo ', TOSTRING(CVALOR(_VALOR))
    else
      write(*,*) 'Nao existe valor associado do tipo ', TOSTRING(CVALOR(_VALOR))
    end if
  end subroutine MOSCAPSULA(_VALOR_)

  subroutine ALOCAPSULA(_VALOR_) (self)  
    class(C_Capsula)					:: self
    integer						:: status
    !Se ja tem valor alocado, desaloca
    if ( self%tem() ) call self%desaloca()
    !aloca
    allocate( SELFCAPSULA(_VALOR_), STAT = status )
    if ( status .ne. 0 ) write(*,*) 'Erro: alocacao falhou'
    if ( .not. self%tem() ) write(*,*) 'Error: alocacao falhou!'
  end subroutine ALOCAPSULA(_VALOR_)

  subroutine DESCAPSULA(_VALOR_) (self)
    class(C_Capsula)					:: self
    integer						:: status
    write(*,*) 'XB'
    if ( associated( SELFCAPSULA(_VALOR_) ) ) then
      write(*,*) 'XC'
      deallocate( SELFCAPSULA(_VALOR_), STAT = status )
    if ( status .ne. 0 ) write(*,*) 'Erro: desalocacao falhou'
      write(*,*) 'XD'
    end if
    nullify( SELFCAPSULA(_VALOR_) )
    write(*,*) 'XE'
  end subroutine DESCAPSULA(_VALOR_)

  subroutine ENCAPSULA(_VALOR_) ( invalor, capsula, re )
    type(CVALOR(_VALOR_)), pointer, intent(in)		:: invalor
    class(C_Capsula), pointer, intent(inout)		:: capsula
    logical, optional					:: re
    type(CVALOR(_VALOR_)), pointer			:: valor => null()
    if ( associated( invalor ) ) then
      valor => invalor
    else
      allocate( valor )
    end if
    if ( .not. ( associated( capsula ) .and. present( re ) .and. re ) ) then
      nullify( capsula )
      allocate( capsula )
    end if
    call capsula%defineGenero( Str( TOSTRING(_VALOR_) ) )
    call capsula%desaloca()
    call DEFCAPSULA(_VALOR_) ( capsula, valor )
  end subroutine ENCAPSULA(_VALOR_) 

  subroutine RECAPSULA(_VALOR_) ( valor, capsula )
    type(CVALOR(_VALOR_)), pointer, intent(in)		:: valor
    class(C_Capsula), pointer, intent(inout)		:: capsula
    call ENCAPSULA(_VALOR_) ( valor, capsula, re = .true. )
  end subroutine RECAPSULA(_VALOR_) 

  function DECAPSULA(_VALOR_) ( capsula, valor ) result( temValor )
    class(C_Capsula), pointer, intent(in)		:: capsula
    type(CVALOR(_VALOR_)), pointer, intent(out)		:: valor => null()
    logical						:: temValor
    temValor = .false.
    if ( associated( capsula ) ) then
      call capsula%defineGenero( Str( TOSTRING(_VALOR_) ) )
      if ( capsula%tem() ) then
        call OBTCAPSULA(_VALOR_) ( capsula, valor )
        temValor = .true.
      end if
    end if
  end function DECAPSULA(_VALOR_) 

!-----------end type-bound procedures of type C_Capsula----------!
