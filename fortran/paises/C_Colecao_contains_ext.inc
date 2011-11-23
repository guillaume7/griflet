!----------------type-bound procedures of type C_colecao(_VALOR_)-------------!

  subroutine ALNODO(_VALOR_) ( new ) !nopass
    class(C_Colecao), pointer, intent(inout)	:: new
    allocate( COLVALOR(_VALOR_) :: new )
    call new%defineTipoObj( Str(TOSTRING(COLVALOR(_VALOR_))) )
  end subroutine ALNODO(_VALOR_)

  subroutine DEFVALOR(_VALOR_) (self, valor)
    class(COLVALOR(_VALOR_))            :: self
    type(CVALOR(_VALOR_)), pointer     	:: valor
    self%valor => valor
  end subroutine DEFVALOR(_VALOR_)

  subroutine OBTVALOR(_VALOR_) (self, valor)
    class(COLVALOR(_VALOR_))                	  	:: self
    type(CVALOR(_VALOR_)), pointer, intent(out)  	:: valor
    valor => self%valor
  end subroutine OBTVALOR(_VALOR_)

  function TEMVALOR(_VALOR_) (self) result(tem)
      class(COLVALOR(_VALOR_))      :: self
      logical                       :: tem
      if ( associated( self%valor ) ) then
        tem = .true.
      else
        tem = .false.
      endif
  end function TEMVALOR(_VALOR_)

  subroutine MOSVALOR(_VALOR_) (self)
    class(COLVALOR(_VALOR_))		:: self
    type(CVALOR(_VALOR_)), pointer 	:: valor
    call OBTVALOR(_VALOR_) ( self, valor)
    call valor%mostrarTipoObj()    
  end subroutine MOSVALOR(_VALOR_)

  subroutine ALOVALOR(_VALOR_) (self)
    class(COLVALOR(_VALOR_))                                :: self
    type(CVALOR(_VALOR_)),pointer							:: valor
    allocate( valor )
    call valor%defineTipoObj( Str(TOSTRING(CVALOR(_VALOR_))) )
    call DEFVALOR(_VALOR_) (self, valor)
  end subroutine ALOVALOR(_VALOR_)

  subroutine DESVALOR(_VALOR_) (self)
    class(COLVALOR(_VALOR_))                               	:: self
    deallocate( self%valor )
    nullify( self%valor )
  end subroutine DESVALOR(_VALOR_)

  !-----------end type-bound procedures of type C_colecao(_VALOR_)----------!
