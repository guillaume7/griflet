module class_paises

  implicit none

  integer, parameter            :: StringLength = 128

  public                        :: C_paises

  type                          :: C_paises

    character(len=StringLength) :: nome

    character(len=StringLength) :: capital

    real                        :: pop

    real                        :: pib

  contains

    !Constructor

    procedure :: fundar         => fundar_pais

    !Sets

    !Gets
    
    !C_paises methods
    
    procedure  explorar         => explorar_pais
    
    !Destructor

  end type C_paises

contains

  !Constructor
  
  subroutine fundar_pais(self)

    class(C_paises)  :: self

    write(*,*) 'Descoberta dum novo Mundo:'

    write(*,*) ''

    write(*,*) 'Insira o nome do pais'
    
    read(*,*) self%nome

    write(*,*) 'Insira a sua capital'
    
    read(*,*) self%capital

    write(*,*) 'Insira a populacao em milhoes de habitantes'
    
    read(*,*) self%pop

    write(*,*) 'Insira o PIB em milhoes de euros'
    
    read(*,*) self%pib

    write(*,*) ''

  end subroutine fundar_pais
  
  !Gets
  
  subroutine explorar_pais(self)

    class(C_paises)            :: self

    write(*,*) 'O pais ', trim(self%nome),','
    
    write(*,*) 'cuja capital eh ', trim(self%capital),','
    
    write(*,*) 'tem uma populacao de', self%pop,'habitantes'
    
    write(*,*) 'e um pib de ', self%pib, 'milhoes de euros.'

  end subroutine explorar_pais
  
end module class_paises

!----------------- Programa ----------------------

#ifndef _TEMPLATING

program unitTests_paises

  use class_paises

  implicit none

  integer                 :: i

  !Inovação: destruamos o Me e conseguiremos
  !criar naturalmente várias instâncias de
  !atlases (ou colecções de mapas).

  type(C_paises)            :: mapaTerrestre

  type(C_paises)            :: mapaLunar

  !Descobrir e explorar a Terra

  write(*,*) 'Hello world!'

end program unitTests_paises

#endif
