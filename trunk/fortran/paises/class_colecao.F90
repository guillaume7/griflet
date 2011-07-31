module class_colecao

  implicit none

  private

  public C_Colecao

  type C_Colecao

    integer                         :: id = 1

    class(C_Colecao), pointer       :: fundador => null()

    class(C_Colecao), pointer       :: seguinte => null()

  contains

    procedure                       :: obterIterador => obterIterador_item

    procedure, nopass               :: paraCada => paraCada_item

    procedure                       :: adicionar => adicionar_nodo

    procedure                       :: remover => remover_nodo

    procedure                       :: removerTudo => remover_lista
 
    procedure                       :: obter => obter_nodo

    procedure                       :: obterPrimeiro => obterPrimeiro_nodo

    procedure                       :: obterSeguinte => obterSeguinte_nodo
 
    procedure                       :: obterAnterior => obterAnterior_nodo

    procedure                       :: obterUltimo => obterUltimo_nodo

    procedure                       :: mostrarId => mostrarId_nodo

    procedure                       :: mostrar => mostrar_lista

  end type C_Colecao

contains

  function obterIterador_item(self) result(item)

    class(C_Colecao), target      :: self

    class(C_Colecao), pointer     :: item

    allocate(item)

    item%id = 0

    item%fundador => self%fundador

    item%seguinte => self

  end function obterIterador_item

  function paraCada_item(item) result(keepup)

    class(C_Colecao), pointer, intent(inout)     :: item

    logical                       :: keepup

    if ( associated(item%seguinte) ) then

      item => item%seguinte

      keepup = .true.

    else

      item => null()

      keepup = .false.

    end if

  end function paraCada_item

  subroutine adicionar_nodo(self)

    class(C_Colecao), target      :: self

    class(C_Colecao), pointer     :: new

    integer                       :: id

    if ( .not. associated( self%fundador ) ) then

      self%fundador => self

    end if

    new => self.obterUltimo()

    allocate(new%seguinte)

    id = new%id

    new => new%seguinte

    new%id = id + 1

    new%fundador => self%fundador

    new%seguinte => null()

    write(*,*) 'Criado item numero ', new%id

  end subroutine adicionar_nodo

  subroutine remover_nodo(self)

    class(C_Colecao)             :: self

    class(C_Colecao), pointer    :: ultimo, penultimo

    ultimo => self.obterUltimo()

    penultimo => ultimo.obterAnterior()

    if ( ultimo%id .eq. penultimo%id ) then

      write(*,*) 'WARN: A lista contem apenas o seu elemento fundador.'

      write(*,*) 'Não se remove o elemento fundador da lista.'

      write(*,*) 'O elemento fundador so pode ser removido externamente.'

    else

      write(*,*) 'Removido item numero ', ultimo%id

      deallocate(ultimo)
      
    endif

    penultimo%seguinte => null()

  end subroutine remover_nodo

  subroutine remover_lista(self)

    class(C_Colecao)              :: self

    class(C_Colecao), pointer     :: first

    first => self.obterPrimeiro();

    do while ( associated ( first%seguinte ) )

      call first.remover()

    end do

    write(*,*) 'Lista esvaziada.'

    write(*,*) ''

  end subroutine remover_lista

  function obter_nodo(self,id) result(nodo)

    class(C_Colecao)              :: self

    integer                       :: id

    class(C_Colecao), pointer     :: nodo

    nodo => self%fundador

    do while ( nodo%id .ne. id )

      if ( associated( nodo%seguinte ) ) then

        nodo => nodo%seguinte

      else

        id = nodo%id

        write(*,*) 'WARN 000: Nao se encontrou o nodo ', id, ' na colecao.'

      end if

    end do

  end function obter_nodo

  function obterPrimeiro_nodo(self) result(primeiro)

    class(C_Colecao)              :: self

    class(C_Colecao), pointer     :: primeiro

    primeiro => self%fundador

  end function obterPrimeiro_nodo

  function obterAnterior_nodo(self) result(anterior)

    class(C_Colecao)              :: self

    class(C_Colecao), pointer     :: anterior, seguinte

    integer                       :: id

    anterior => self%fundador

    if ( self%id .ne. anterior%id ) then

      seguinte => anterior%seguinte

      id = seguinte%id

      do while ( id .ne. self%id )

        if ( associated( seguinte%seguinte ) ) then
      
          anterior => anterior%seguinte

          seguinte => seguinte%seguinte

          id = seguinte%id

        else

          id = self%id

          write(*,*) 'WARN 001: Nao foi encontrado o nodo anterior na colecao'
          write(*,*) 'Colecao corrompida.'

        endif

      end do

    endif

  end function obterAnterior_nodo

  function obterSeguinte_nodo(self) result(seguinte)

    class(C_Colecao), target      :: self

    class(C_Colecao), pointer     :: seguinte

    seguinte => self

    if ( associated( self%seguinte ) ) then

      seguinte => self%seguinte

    end if

  end function obterSeguinte_nodo

  function obterUltimo_nodo(self) result(ultimo)

    class(C_Colecao), target      :: self

    class(C_Colecao), pointer     :: ultimo

    ultimo => self

    do while ( associated( ultimo%seguinte ) )

      ultimo => ultimo%seguinte

    end do

  end function obterUltimo_nodo

  subroutine mostrarId_nodo(self)

    class(C_Colecao)          :: self

    class(C_Colecao), pointer :: ptr

    ptr => self.obterAnterior()

    if ( self%id .eq. ptr%id ) then

      write(*,*) 'O item e o fundador da lista.'

    else

      write(*,*) 'O item anterior tem numero ', ptr%id

    end if

    write(*,*) 'O numero do item e o ', self%id

    ptr => self.obterSeguinte()

    if ( self%id .eq. ptr%id ) then

      write(*,*) 'O item e o ultimo da lista.'

    else

      write(*,*) 'O item seguinte tem numero', ptr%id

    end if

    write(*,*) ''


  end subroutine mostrarId_nodo

  subroutine mostrar_lista(self)

    class(C_Colecao)          :: self

    class(C_Colecao), pointer :: item

    item => self.obterIterador()

    do while ( self.paraCada(item) )

      call item.mostrarId()

    end do

    write(*,*) 'Lista mostrada.'

    write(*,*) ''

  end subroutine mostrar_lista

end module class_colecao

!----------------- Program -----------------------------

program test_colecao

  use class_colecao

  implicit none

  type(C_Colecao)             :: lista

  integer                     :: i

  do i = 2, 15

    call lista.adicionar()

  end do

  write(*,*) ''

  call lista.mostrar()

  call lista.removerTudo()

  call lista.mostrar()

end program test_colecao
