module class_colecao

  implicit none

  private

  public C_Colecao

  type C_Colecao

    integer                         :: id = 1

    class(C_Colecao), pointer       :: fundador => null()

    class(C_Colecao), pointer       :: seguinte => null()

  contains

    procedure                       :: adicionar => adicionar

    procedure                       :: remover => remover

    procedure                       :: removerTudo => removerTudo
 
    procedure                       :: obter => obter

    procedure                       :: obterPrimeiro => obterPrimeiro

    procedure                       :: obterSeguinte => obterSeguinte
 
    procedure                       :: obterAnterior => obterAnterior

    procedure                       :: obterUltimo => obterUltimo

  end type C_Colecao

contains

  subroutine adicionar(self)

    class(C_Colecao), target      :: self

    class(C_Colecao), pointer     :: new

    integer                       :: id

    new => self.obterUltimo()

    allocate(new%seguinte)

    id = new%id

    new => new%seguinte

    new%id = id + 1

  end subroutine adicionar

  subroutine remover(self)

    class(C_Colecao)             :: self

    class(C_Colecao), pointer    :: ptr

    ptr => self.obterUltimo()

    deallocate(ptr)

  end subroutine remover

  subroutine removerTudo(self)

    class(C_Colecao)              :: self

    class(C_Colecao), pointer     :: ptr, first

    first => self.obterPrimeiro();

    do while ( associated ( first ) )

      call first.remover()

    end do

  end subroutine removerTudo

  function obter(self,id) result(nodo)

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

  end function obter

  function obterPrimeiro(self) result(primeiro)

    class(C_Colecao)              :: self

    class(C_Colecao), pointer     :: primeiro

    primeiro => self%fundador

  end function obterPrimeiro

  function obterAnterior(self) result(anterior)

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

  end function obterAnterior

  function obterSeguinte(self) result(seguinte)

    class(C_Colecao), target      :: self

    class(C_Colecao), pointer     :: seguinte

    seguinte => self

    if ( associated( self%seguinte ) ) then

      seguinte => self%seguinte

    end if

  end function obterSeguinte

  function obterUltimo(self) result(ultimo)

    class(C_Colecao), target      :: self

    class(C_Colecao), pointer     :: ultimo

    ultimo => self

    do while ( associated( ultimo%seguinte ) )

      ultimo => ultimo%seguinte

    end do

  end function obterUltimo

end module class_colecao

!----------------- Program -----------------------------

program test_colecao

  use class_colecao

  implicit none

  type(C_Colecao) :: list

  integer         :: i

  list = C_Colecao(1)
  
  do i = 1, 3

    call list.adicionar()

  end do

  call list.removerTudo()

end program test_colecao
