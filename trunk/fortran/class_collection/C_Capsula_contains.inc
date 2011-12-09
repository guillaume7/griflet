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

!----------------class-bound procedures of class C_Capsula-------------!

  subroutine DEFCAPSULA(_VALOR_) (self, valor)
    class(C_Capsula), intent(inout) 			:: self
    class(CVALOR(_VALOR_)),pointer, intent(in)		:: valor
    SELFCAPSULA(_VALOR_) => valor
  end subroutine
  
  subroutine OBTCAPSULA(_VALOR_) (self, valor)
    class(C_Capsula), intent(in)				:: self
    class(CVALOR(_VALOR_)), pointer, intent(out)		:: valor
    if ( self%tem() ) then
      valor => SELFCAPSULA(_VALOR_)
    else
      nullify( valor )
    end if	
  end subroutine

  function TEMCAPSULA(_VALOR_) (self) result(tem)
    class(C_Capsula), intent(in)			:: self
    logical						:: tem
    if ( associated( SELFCAPSULA(_VALOR_) ) ) then
      tem = .true.
    else
      tem = .false.
    end if
  end function
  
  subroutine MOSCAPSULA(_VALOR_) (self)
    class(C_Capsula), intent(in)			:: self
    if ( associated ( self%tem ) ) then
      if ( self%tem() ) then
        write(*,*) 'O valor é do tipo ', TOSTRING(CVALOR(_VALOR_))
      else
        write(*,*) 'Nao existe valor associado do tipo ', TOSTRING(CVALOR(_VALOR_))
      end if
    end if
  end subroutine

  subroutine ALOCAPSULA(_VALOR_) (self)  
    class(C_Capsula), intent(inout)			:: self
    integer						:: status
    !Se ja tem valor alocado, desaloca
    if ( associated( self%tem ) ) then
      if ( self%tem() ) call self%desaloca()
    end if
    !aloca
    allocate( SELFCAPSULA(_VALOR_), STAT = status )
    if ( status .ne. 0 ) write(*,*) 'Erro: alocacao falhou'
    if ( .not. self%tem() ) then
      write(*,*) 'Error: alocacao falhou!'
    else
      write(*,*) 'Criado um novo elemento na capsula do tipo ', TOSTRING(CVALOR(_VALOR_))
    end if
  end subroutine

  subroutine DESCAPSULA(_VALOR_) (self)
    class(C_Capsula), intent(inout)			:: self
    integer						:: status
    if ( associated( SELFCAPSULA(_VALOR_) ) ) then
      deallocate( SELFCAPSULA(_VALOR_), STAT = status )
      if ( status .ne. 0 ) write(*,*) 'Erro: desalocacao falhou'
      if ( self%tem() ) then
        write(*,*) 'Error: alocacao falhou!'
      else
        write(*,*) 'Removido o elemento na capsula do tipo ', TOSTRING(CVALOR(_VALOR_))
      end if
      nullify( SELFCAPSULA(_VALOR_) )
    end if
  end subroutine

  subroutine ENCAPSULA(_VALOR_) ( invalor, capsula, re )
    class(CVALOR(_VALOR_)), pointer, intent(in)		:: invalor
    class(C_Capsula), pointer, intent(inout)		:: capsula
    logical, optional					:: re
    class(CVALOR(_VALOR_)), pointer			:: valor => null()
    if ( .not. ( associated( capsula ) .and. present( re ) .and. re ) ) then
      nullify( capsula )
      allocate( capsula )
    end if
    call capsula%desaloca()
    if ( associated( invalor ) ) then
      valor => invalor
      call DEFCAPSULA(_VALOR_) ( capsula, valor )
      write(*,*) 'Adicionado um novo elemento na capsula do tipo ', TOSTRING(CVALOR(_VALOR_))
    else
      call ALOCAPSULA(_VALOR_) ( capsula )
    end if
  end subroutine

  subroutine RECAPSULA(_VALOR_) ( valor, capsula )
    class(CVALOR(_VALOR_)), pointer, intent(in)		:: valor
    class(C_Capsula), pointer, intent(inout)		:: capsula
    call ENCAPSULA(_VALOR_) ( valor, capsula, re = .true. )
  end subroutine

  function DECAPSULA(_VALOR_) ( capsula, valor ) result( temValor )
    class(C_Capsula), pointer, intent(in)		:: capsula
    class(CVALOR(_VALOR_)), pointer, intent(out)	:: valor
    logical						:: temValor
    temValor = .false.
    nullify( valor )
    if ( associated( capsula ) ) then
      call capsula%defineGenero( TOSTRING(_VALOR_) )
      call capsula%defineGenero( TOSTRING(_VALOR_) )
      if ( capsula%tem() ) then
        call OBTCAPSULA(_VALOR_) ( capsula, valor )
        temValor = .true.
      end if
    end if
  end function 

!-----------end class-bound procedures of class C_Capsula----------!
