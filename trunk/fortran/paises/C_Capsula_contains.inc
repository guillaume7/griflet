#ifndef _VALOR_
#define _VALOR_ Objecto
#endif

#ifndef _PRESCAN_
#define _PRESCAN_
#define AFTERDEF(x) define ## x
#define DEFCAPSULA(x) AFTERDEF(x)
#define AFTEROBT(x) obter ## x
#define OBTCAPSULA(x) AFTEROBT(x)
#define AFTERTEM(x) tem ## x
#define TEMCAPSULA(x) AFTERTEM(x)
#define AFTERMOS(x) mostrar ## x
#define MOSCAPSULA(x) AFTERMOS(x)
#define AFTERSELF(x) self% ## x
#define SELFCAPSULA(x) AFTERSELF(x)
#define AFTERALO(x) alocar ## x
#define ALOCAPSULA(x) AFTERSELF(x)
#define AFTERDES(x) desalocar ## x
#define DESCAPSULA(x) AFTERSELF(x)
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
  end subroutine DEFCAPSULA
  
  subroutine OBTCAPSULA(_VALOR_) (self, valor)
    class(C_Capsula)								:: self
    type(CVALOR(_VALOR_)),pointer, intent(out)		:: valor
    if ( SELFCAPSULA(TEMCAPSULA(_VALOR_)) ) then
  	  valor => SELFCAPSULA(_VALOR_)
  	else
  	  nullify( valor )
  	end if	
  end subroutine OBTCAPSULA

  function TEMCAPSULA(_VALOR_) (self) result(tem)
    class(C_Capsula)						:: self
    logical									:: tem
    if ( associated( SELFCAPSULA(_VALOR_) ) ) then
      tem = .true.
    else
      tem = .false.
    end if
  end function TEMCAPSULA(_VALOR_)
  
  subroutine MOSCAPSULA(_VALOR_) (self)
    class(C_Capsula)						:: self
    write(*,*) 'O valor é do tipo ', TOSTRING(CVALOR(_VALOR))    
  end subroutine MOSCAPSULA(_VALOR_)

  subroutine ALOCAPSULA(_VALOR_) (self)  
    class(C_Capsula)						:: self
    type(CVALOR(_VALOR_), pointer			:: valor
    !Se ja tem valor alocado, desaloca
    if ( SELFCAPSULA(TEMCAPSULA(_VALOR_)) ) call SELFCAPSULA(DESCAPSULA(_VALOR_))
    !aloca
    allocate( valor )
    call self%DEFCAPSULA(_VALOR_) ( valor )
  end subroutine ALOCAPSULA(_VALOR_)

  subroutine DESCAPSULA(_VALOR_) (self)
    class(C_Capsula)						:: self
    type(CVALOR(_VALOR_), pointer			:: valor
    call SELFCAPSULA(OBTCAPSULA(_VALOR_)) (valor)
	deallocate( valor )
	nullify( SELFCAPSULA(_VALOR_) )
  end subroutine DESCAPSULA(_VALOR_)

!-----------end type-bound procedures of type C_Capsula----------!
