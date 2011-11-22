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

!-----------end type-bound procedures of type C_Capsula----------!
