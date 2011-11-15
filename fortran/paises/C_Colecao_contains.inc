 !----------------type-bound procedures of type C_colecao(_VALOR_)-------------!

  subroutine DEFVALOR(_VALOR_) (self, valor)
    class(C_colecao)              :: self
    class(CVALOR(_VALOR_)), pointer     :: valor
    self%_VALOR_ => valor
  end subroutine DEFVALOR(_VALOR_)

  subroutine OBTVALOR(_VALOR_) (self, valor)
    class(C_colecao)                       :: self
    class(CVALOR(_VALOR_)), pointer, intent(out)  :: valor
    valor => self%_VALOR_
  end subroutine OBTVALOR(_VALOR_)

  function TEMVALOR(_VALOR_) (self) result(tem)
      class(C_colecao)              :: self
      logical                       :: tem
      if ( associated(self%_VALOR_) ) then
        tem = .true.
      else
        tem = .false.
      endif
  end function TEMVALOR(_VALOR_)

  subroutine ADIVALOR(_VALOR_) (self, valor)
    class(C_colecao)                                      :: self
    class(CVALOR(_VALOR_)), pointer, intent(in)           :: valor
    class(C_colecao), pointer                             :: ptr => null()
    if ( associated( valor ) ) then
      call self%adicionarNodo()
      call self%obterUltimo( ptr )
      call ptr%DEFVALOR(_VALOR_)( valor )
      write(*,*) 'de tipo ', trim( valor%obterTipoObj() )
    else
      write(*,*) 'Err: valor não está associado.'
    endif
  end subroutine ADIVALOR(_VALOR_)

  subroutine ALOVALOR(_VALOR_) (valor) !nopass
    class(CVALOR(_VALOR_)), pointer, intent(inout)        :: valor
    allocate( CVALOR(_VALOR_) :: valor )
  end subroutine ALOVALOR(_VALOR_)

  subroutine DESVALOR(_VALOR_) (valor) !nopass
    class(CVALOR(_VALOR_)), pointer, intent(inout)        :: valor
    deallocate( valor )
    nullify( valor )
  end subroutine DESVALOR(_VALOR_)

  !-----------end type-bound procedures of type C_colecao(_VALOR_)----------!
