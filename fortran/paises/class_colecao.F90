module class_colecao

  !When using classes in fortran 2003, try considering that'%' and 'target' 

  !are forbidden directives, except in 'get' and 'set' methods.

  implicit none

  private

  public C_Colecao

  type C_Colecao

    integer                         :: id = 1

    class(C_Colecao), pointer       :: fundador => null()

    class(C_Colecao), pointer       :: seguinte => null()

  contains

    !Constructors

    procedure                       :: iniciar => iniciar_lista	

	!Sets ( '%' allowed for writing )

	procedure                       :: defineId => defineId_nodo ! ( 'target' allowed )

	procedure                       :: definePrimeiro => definePrimeiro_nodo

	procedure                       :: defineSeguinte => defineSeguinte_nodo

    !Gets ( '%' allowed for reading)

	procedure                       :: obterProprio => obterProprio_nodo

	procedure                       :: obterId => obterId_nodo

    procedure                       :: obterPrimeiro => obterPrimeiro_nodo

    procedure                       :: obterSeguinte => obterSeguinte_nodo

    !C_Colecao methods

    procedure                       :: adicionar => adicionar_nodo

    procedure		                :: paraCada => paraCada_item

    procedure                       :: obter => obter_nodo	

    procedure                       :: obterAnterior => obterAnterior_nodo

    procedure                       :: obterUltimo => obterUltimo_nodo

    procedure                       :: mostrarId => mostrarId_nodo

    procedure                       :: mostrar => mostrar_lista

    procedure                       :: remover => remover_nodo

	!Destructors

    procedure                       :: finalizar => remover_lista

  end type C_Colecao

contains

  !Constructors

  subroutine iniciar_lista(self, id)

    class(C_Colecao)              :: self

	integer, optional             :: id

    if ( .not. associated( self.obterPrimeiro() ) ) then

      if ( present(id) ) then

	    call self.defineId( id )

	  end if

	  call self.definePrimeiro( self.obterProprio() )

      write(*,*) 'Criado item numero ', self.obterId()

	end if

  end subroutine iniciar_lista

  !Sets ( '%' allowed for writing )

  subroutine defineId_nodo(self, id)

    class(C_Colecao)              :: self

	integer                       :: id

	self%id = id

  end subroutine defineId_nodo

  subroutine definePrimeiro_nodo(self, primeiro)

    class(C_Colecao)              :: self

	class(C_Colecao), pointer     :: primeiro

	self%fundador => primeiro

  end subroutine definePrimeiro_nodo

  subroutine defineSeguinte_nodo(self, seguinte)

    class(C_Colecao)              :: self

	class(C_Colecao), pointer     :: seguinte

	self%seguinte => seguinte

  end subroutine defineSeguinte_nodo

  !Gets ( '%' allowed for reading) 

  function obterProprio_nodo(self) result(proprio)

	class(C_Colecao), target      :: self

	class(C_Colecao), pointer     :: proprio

	proprio => self

  end function obterProprio_nodo

  function obterId_nodo(self) result(id)

	class(C_Colecao)              :: self

	integer                        :: id

	id = self%id

  end function obterId_nodo

  function obterPrimeiro_nodo(self) result(primeiro)

    class(C_Colecao)              :: self

    class(C_Colecao), pointer     :: primeiro

    primeiro => self%fundador

  end function obterPrimeiro_nodo

  function obterSeguinte_nodo(self) result(seguinte)

    class(C_Colecao)              :: self

    class(C_Colecao), pointer     :: seguinte

    if ( associated( self%seguinte ) ) then

      seguinte => self%seguinte

    else

	  seguinte => null()

    end if

  end function obterSeguinte_nodo

  !C_Colecao methods

  subroutine adicionar_nodo(self)

    class(C_Colecao)              :: self

    class(C_Colecao), pointer     :: ultimo, new

    integer                       :: id

    if ( .not. associated( self.obterPrimeiro() ) ) then

	  call self.iniciar()

    end if

    ultimo => self.obterUltimo()

    allocate(new)

    call new.defineId( ultimo.obterId() + 1 )

    call new.definePrimeiro( self.obterPrimeiro() )

    call ultimo.defineSeguinte( new )

    write(*,*) 'Criado item numero ', new.obterId()

  end subroutine adicionar_nodo

  function paraCada_item(self, item) result(keepup)

    !Simulates 'for each <item> in <List> do ... end do'
    !usage: do while ( Lista.paraCada (item) )
    !usage: ...
    !usage: end do

    class(C_Colecao)                             :: self

    class(C_Colecao), pointer, intent(inout)     :: item

	class(C_Colecao), pointer					 :: itemZero => null()

    logical                                      :: keepup

	if ( .not. associated(item) ) then

	    allocate(itemZero)

		call itemZero.defineId(0)

		call itemZero.definePrimeiro( self.obterPrimeiro() )

		call itemZero.defineSeguinte( self.obterProprio() )

		item => itemZero

	end if

    if ( associated( item.obterSeguinte() ) ) then

      item => item.obterSeguinte()

      keepup = .true.

    else

      item => null()

      keepup = .false.

    end if

	if ( associated(itemZero) ) then

	  deallocate(itemZero)

	end if

  end function paraCada_item

  function obter_nodo(self,id) result(nodo)

    class(C_Colecao)              :: self

    integer                       :: id

    class(C_Colecao), pointer     :: nodo

    nodo => self.obterPrimeiro()

    do while ( nodo.obterId() .ne. id )

      if ( associated( nodo.obterSeguinte() ) ) then

        nodo => nodo.obterSeguinte()

      else

        id = nodo.obterId()

        write(*,*) 'WARN 000: Nao se encontrou o nodo ', id, ' na colecao.'

      end if

    end do

  end function obter_nodo

  function obterAnterior_nodo(self) result(anterior)

    class(C_Colecao)              :: self

    class(C_Colecao), pointer     :: anterior, seguinte

    integer                       :: id

    anterior => self.obterPrimeiro()

    if ( self.obterId() .ne. anterior.obterId() ) then

      seguinte => anterior.obterSeguinte()

      id = seguinte.obterId()

      do while ( id .ne. self.obterId() )

        if ( associated( seguinte.obterSeguinte() ) ) then

          anterior => anterior.obterSeguinte()

          seguinte => seguinte.obterSeguinte()

          id = seguinte.obterId()

        else

          id = self.obterId()

          write(*,*) 'WARN 001: Nao foi encontrado o nodo anterior na colecao'

          write(*,*) 'Colecao corrompida.'

        endif

      end do

    endif

  end function obterAnterior_nodo

  function obterUltimo_nodo(self) result(ultimo)

    class(C_Colecao)              :: self

    class(C_Colecao), pointer     :: ultimo

    ultimo => self.obterProprio()

    do while ( associated( ultimo.obterSeguinte() ) )

      ultimo => ultimo.obterSeguinte()

    end do

  end function obterUltimo_nodo

  subroutine mostrarId_nodo(self)

    class(C_Colecao)          :: self

    class(C_Colecao), pointer :: ptr

    ptr => self.obterAnterior()

    if ( self.obterId() .eq. ptr.obterId() ) then

      write(*,*) 'O item e o fundador da lista.'

    else

      write(*,*) 'O item anterior tem numero ', ptr.obterId()

    end if

    write(*,*) 'O numero do item e o ', self.obterId()

    ptr => self.obterSeguinte()

    if ( .not. associated(ptr) ) then

      write(*,*) 'O item e o ultimo da lista.'

    else

      write(*,*) 'O item seguinte tem numero', ptr.obterId()

    end if

    write(*,*) ''

  end subroutine mostrarId_nodo

  subroutine mostrar_lista(self)

    class(C_Colecao)          :: self

    class(C_Colecao), pointer :: item => null()

    do while ( self.paraCada(item) )

      call item.mostrarId()

    end do

    write(*,*) 'Lista mostrada.'

    write(*,*) ''

  end subroutine mostrar_lista

  subroutine remover_nodo(self)

    class(C_Colecao)             :: self

    class(C_Colecao), pointer    :: ultimo, penultimo

    ultimo => self.obterUltimo()

    penultimo => ultimo.obterAnterior()

    if ( ultimo.obterId() .eq. penultimo.obterId() ) then

      write(*,*) 'WARN: A lista contem apenas o seu elemento fundador.'

      write(*,*) 'Não se remove o elemento fundador da lista.'

      write(*,*) 'O elemento fundador so pode ser removido externamente.'

    else

      write(*,*) 'Removido item numero ', ultimo.obterId()

      deallocate(ultimo)

    endif

    call penultimo.defineSeguinte( null() )

  end subroutine remover_nodo

  !Destructors

  subroutine remover_lista(self)

    class(C_Colecao)              :: self

    class(C_Colecao), pointer     :: first

    first => self.obterPrimeiro();

    do while ( associated ( first.obterSeguinte() ) )

      call first.remover()

    end do

    write(*,*) 'Lista esvaziada.'

    write(*,*) ''

  end subroutine remover_lista

end module class_colecao

!----------------- Program -----------------------------

program unitTests_Colecao

  use class_colecao

  implicit none

  integer                     :: i

  type(C_Colecao)             :: lista

  call lista.iniciar(1)

  do i = 2, 15

    call lista.adicionar()

  end do

  write(*,*) ''

  call lista.mostrar()

  call lista.finalizar()

  call lista.mostrar()

end program unitTests_Colecao
