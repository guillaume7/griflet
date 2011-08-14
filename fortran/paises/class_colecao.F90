#ifndef COLECAO

#define COLECAO colecao
#define CLASS_COLECAO class_colecao

#endif 

module class_COLECAO

  !When using classes in fortran 2003, try considering that'%' and 'target' 

  !are forbidden directives, except in 'get', 'set' and 'has' methods.

  !Encapsulate in special methods uses of 'associated' and return logical

  !result instead.

  implicit none

  private

  public C_lista_COLECAO

  type                    :: colecao

    !Empty fake type

  end type colecao

  type, extends(COLECAO)  :: C_lista_COLECAO

    integer                         :: id = 1

    integer                         :: _OLA

    integer                         :: COLECAO

    class(C_lista_COLECAO), pointer       :: fundador => null()

    class(C_lista_COLECAO), pointer       :: seguinte => null()

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
    
    !Has ( '%' allowed for checking association )

    procedure                       :: temPrimeiro => temPrimeiro_nodo

    procedure                       :: temSeguinte => temSeguinte_nodo

    !C_lista_COLECAO methods

    procedure                       :: adicionar => adicionar_nodo

    procedure                       :: paraCada => paraCada_item

    procedure                       :: obter => obter_nodo
  
    procedure                       :: obterAnterior => obterAnterior_nodo

    procedure                       :: obterUltimo => obterUltimo_nodo

    procedure                       :: mostrarId => mostrarId_nodo

    procedure                       :: mostrar => mostrar_lista

    procedure                       :: remover => remover_nodo

    !Destructors

    procedure                       :: finalizar => remover_lista

  end type C_lista_COLECAO

contains

  !Constructors

  subroutine iniciar_lista(self, id)

    class(C_lista_COLECAO)              :: self

    class(C_lista_COLECAO), pointer     :: ptr

    integer, optional             :: id

    if ( .not. self.temPrimeiro() ) then      

      if ( present( id ) ) then

        call self.defineId( id )

      end if

      call self.obterProprio( ptr )

      call self.definePrimeiro( ptr )

      nullify( ptr )

      call self.defineSeguinte( ptr )

      write(*,*) 'Criado item numero ', self.obterId()

    end if

  end subroutine iniciar_lista

  !Sets ( '%' allowed for writing )

  subroutine defineId_nodo(self, id)

    class(C_lista_COLECAO)              :: self

    integer                       :: id

    self%id = id

  end subroutine defineId_nodo

  subroutine definePrimeiro_nodo(self, primeiro)

    class(C_lista_COLECAO)              :: self

    class(C_lista_COLECAO), pointer     :: primeiro

    self%fundador => primeiro

  end subroutine definePrimeiro_nodo

  subroutine defineSeguinte_nodo(self, seguinte)

    class(C_lista_COLECAO)              :: self

    class(C_lista_COLECAO), pointer     :: seguinte

    self%seguinte => seguinte

  end subroutine defineSeguinte_nodo

  !Gets ( '%' allowed for reading)
  !It is safer to avoid getting pointers on function returns
  !as they are not (yet as of ifort 12.0) usable directly
  !as arguments. To get pointers it's  best to use
  !subroutine calls.

  subroutine obterProprio_nodo(self, proprio)

    class(C_lista_COLECAO), target                    :: self

    class(C_lista_COLECAO), pointer, intent(out)      :: proprio

    proprio => self

  end subroutine obterProprio_nodo

  function obterId_nodo(self) result(id)

    class(C_lista_COLECAO)              :: self

    integer                        :: id

    id = self%id

  end function obterId_nodo

  subroutine obterPrimeiro_nodo(self, primeiro)

    class(C_lista_COLECAO)                          :: self

    class(C_lista_COLECAO), pointer, intent(out)    :: primeiro

    primeiro => self%fundador

  end subroutine obterPrimeiro_nodo

  subroutine obterSeguinte_nodo(self, seguinte)

    class(C_lista_COLECAO)                        :: self

    class(C_lista_COLECAO), pointer, intent(out)  :: seguinte

    if ( self.temSeguinte() ) then

      seguinte => self%seguinte

    else

      nullify( seguinte )

    end if

  end subroutine obterSeguinte_nodo

  !Has methods

  function temPrimeiro_nodo(self) result(tem)
  
    class(C_lista_COLECAO)              :: self

    logical                       :: tem

    if ( associated( self%fundador ) ) then

      tem = .true.

    else

      tem = .false.

    end if

  end function temPrimeiro_nodo

  function temSeguinte_nodo(self) result(tem)

    class(C_lista_COLECAO)              :: self

    logical                       :: tem

    if ( associated( self%seguinte ) ) then
      
      tem = .true.

    else

      tem = .false.

    end if

  end function temSeguinte_nodo

  !C_lista_COLECAO methods
  
  subroutine adicionar_nodo(self)

    class(C_lista_COLECAO)              :: self

    class(C_lista_COLECAO), pointer     :: ultimo, new, primeiro

    if ( .not. self.temPrimeiro() ) then

      call self.iniciar(1)

    end if

    call self.obterPrimeiro(primeiro)

    call self.obterUltimo(ultimo)

    allocate(new)
    
    call new.defineId( ultimo.obterId() + 1 )

    call new.definePrimeiro( primeiro )

    call ultimo.defineSeguinte( new )

    write(*,*) 'Criado item numero ', new.obterId()

  end subroutine adicionar_nodo

  function paraCada_item(self, item) result(keepup)

    !Simulates 'for each <item> in <List> do ... end do'

    !usage: do while ( Lista.paraCada (item) )

    !usage: ...

    !usage: end do

    class(C_lista_COLECAO)                             :: self

    class(C_lista_COLECAO), pointer, intent(inout)     :: item

    class(C_lista_COLECAO), pointer                    :: ptr, itemZero => null()

    logical                                      :: keepup

    if ( .not. associated( item ) ) then

      allocate( itemZero )

      call itemZero.defineId(0)

      call self.obterPrimeiro(ptr)

      call itemZero.definePrimeiro( ptr )

      call self.obterProprio(ptr)

      call itemZero.defineSeguinte( ptr )

      item => itemZero

    end if

    if ( item.temSeguinte() ) then

      call item.obterSeguinte(item)
  
      keepup = .true.

    else

      nullify( item )
      
      keepup = .false.

    end if

    if ( associated( itemZero ) ) then

      deallocate( itemZero )

    end if

  end function paraCada_item

  subroutine obter_nodo(self, id, nodo)

    class(C_lista_COLECAO)                            :: self

    integer                                     :: id
    
    class(C_lista_COLECAO), pointer, intent(out)      :: nodo

    call self.obterPrimeiro(nodo)

    do while ( nodo.obterId() .ne. id )

      if ( nodo.temSeguinte() ) then

        call nodo.obterSeguinte(nodo)

      else

        id = nodo.obterId()

        write(*,*) 'WARN 000: Nao se encontrou o nodo ', id, ' na colecao.'

      end if

    end do

  end subroutine obter_nodo

  subroutine obterAnterior_nodo(self, anterior)

    class(C_lista_COLECAO)                            :: self

    class(C_lista_COLECAO), pointer, intent(out)      :: anterior
    
    class(C_lista_COLECAO), pointer                   :: seguinte

    call self.obterPrimeiro(anterior)

    if ( self.obterId() .ne. anterior.obterId() ) then

      call anterior.obterSeguinte(seguinte)

      do while ( seguinte.obterId() .ne. self.obterId() )

        if ( seguinte.temSeguinte() ) then

          call anterior.obterSeguinte(anterior)

          call seguinte.obterSeguinte(seguinte)

        else

          write(*,*) 'WARN 001: Nao foi encontrado o nodo anterior na colecao'

          write(*,*) 'lista_COLECAO corrompida.'

          exit
          
        endif

      end do

    endif

  end subroutine obterAnterior_nodo

  subroutine obterUltimo_nodo(self, ultimo)

    class(C_lista_COLECAO)                            :: self

    class(C_lista_COLECAO), pointer, intent(out)      :: ultimo

    call self.obterProprio(ultimo)

    do while ( ultimo.temSeguinte() )

      call ultimo.obterSeguinte(ultimo)

    end do

  end subroutine obterUltimo_nodo

  subroutine mostrarId_nodo(self)

    class(C_lista_COLECAO)          :: self

    class(C_lista_COLECAO), pointer :: ptr

    call self.obterAnterior(ptr)

    if ( self.obterId() .eq. ptr.obterId() ) then

      write(*,*) 'O item e o fundador da lista.'

    else

      write(*,*) 'O item anterior tem numero ', ptr.obterId()

    end if

    write(*,*) 'O numero do item e o ', self.obterId()

    call self.obterSeguinte(ptr)

    if ( .not. self.temSeguinte() ) then

      write(*,*) 'O item e o ultimo da lista.'

    else

      write(*,*) 'O item seguinte tem numero', ptr.obterId()

    end if

    write(*,*) ''

  end subroutine mostrarId_nodo

  subroutine mostrar_lista(self)

    class(C_lista_COLECAO)          :: self

    class(C_lista_COLECAO), pointer :: item => null()

    do while ( self.paraCada(item) )

      call item.mostrarId()

    end do

    write(*,*) 'Lista mostrada.'

    write(*,*) ''

  end subroutine mostrar_lista

  subroutine remover_nodo(self)

    class(C_lista_COLECAO)             :: self

    class(C_lista_COLECAO), pointer    :: ultimo, penultimo, ptr

    call self.obterUltimo(ultimo)

    call ultimo.obterAnterior(penultimo)

    if ( ultimo.obterId() .eq. penultimo.obterId() ) then

      write(*,*) 'WARN: A lista contem apenas o seu elemento fundador.'

      write(*,*) 'Não se remove o elemento fundador da lista.'

      write(*,*) 'O elemento fundador so pode ser removido externamente.'

    else

      write(*,*) 'Removido item numero ', ultimo.obterId()

      deallocate(ultimo)

    endif

    nullify( ptr )

    call penultimo.defineSeguinte( ptr )

  end subroutine remover_nodo

  !Destructors

  subroutine remover_lista(self)

    class(C_lista_COLECAO)              :: self

    class(C_lista_COLECAO), pointer     :: first

    call self.obterPrimeiro(first)

    do while ( first.temSeguinte() )

      call first.remover()

    end do

    write(*,*) 'Lista esvaziada.'

    write(*,*) ''

  end subroutine remover_lista

end module class_colecao

!----------------- Program -----------------------------

program unitTests_lista_COLECAO

  use class_colecao

  implicit none

  integer                     :: i

  type(C_lista_COLECAO)             :: lista

  do i = 1, 15

    call lista.adicionar()

  end do

  write(*,*) ''

  call lista.mostrar()

  call lista.finalizar()

  call lista.mostrar()
  
  pause

end program unitTests_lista_COLECAO
