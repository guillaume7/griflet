        module moduleMapaMundo

        implicit none

        private

        !Declaração do alcance das subrotinas
        !Rotinas que mexem com o tipo "T_Pais"
        private :: fundarPais
        private :: explorarPais
        !Rotinas que mexem com o tipo "T_Mapa"
        public :: descobrirNovoMundo
        private :: criarMapa
        private :: viajarFimDoMundo
        private :: viagemRegresso
        private :: viajarSeguinte
        private :: viajarAnterior
        public :: verMapaMundo
        public :: verMapa
        public :: procurarMapa
        public :: abandonarNovoMundo
        public :: apocalipse

        !Declaração de tipos e variáveis globais do módulo
        public :: StringLength
        integer, parameter  :: StringLength = 128
        
        public :: T_Pais
        type T_Pais
                character(len=StringLength) :: nome
                character(len=StringLength) :: capital
                real                        :: pop
                real                        :: pib
        end type T_Pais

        public :: T_Mapa
        type T_Mapa
                type(T_Pais)            :: pais
                type(T_Mapa), pointer   :: mapaDeCasa => Null()
                type(T_Mapa), pointer   :: mapaSeguinte => Null()
        end type T_Mapa

        type(T_Mapa), pointer          :: Me => Null()

        contains

        subroutine fundarPais(pais)

                type(T_Pais) :: pais

                write(*,*) 'Insira o nome do pais'
                read(*,*) pais%nome

                write(*,*) 'Insira a sua capital'
                read(*,*) pais%capital

                write(*,*) 'Insira a populacao em milhoes de habitantes'
                read(*,*) pais%pop

                write(*,*) 'Insira o PIB em milhoes de euros'
                read(*,*) pais%pib

                write(*,*) ''

        end subroutine fundarPais

        subroutine explorarPais(pais)

                type(T_Pais)            :: pais

                write(*,*) 'O pais ', trim(pais%nome),','
                write(*,*) 'cuja capital eh ', trim(pais%capital),','
                write(*,*) 'tem uma populacao de', pais%pop,'habitantes'
                write(*,*) 'e um pib de ', pais%pib, 'milhoes de euros.'

        end subroutine explorarPais

        subroutine descobrirNovoMundo()

                !Se o mapa ainda não existe, então é criado
                if (.not. associated(Me)) then

                        call criarMapa(Me,Me)

                !Senão o Atlas é incrementado
                else

                        call viajarFimDoMundo

                        call criarMapa(Me%mapaSeguinte, Me%mapaDeCasa)

                        Me => Me%mapaSeguinte

                end if

                call fundarPais(Me%pais)

        end subroutine descobrirNovoMundo

        subroutine viajarFimDoMundo()

                do while (associated(Me%mapaSeguinte))

                        Me => Me%mapaSeguinte

                end do  

        end subroutine viajarFimDoMundo

        subroutine viagemRegresso()

                if(associated(Me)) then

                    Me => Me%mapaDeCasa

                endif

        end subroutine viagemRegresso
        
        subroutine viajarSeguinte()

            if(associated(Me)) then

                if(associated(Me%mapaSeguinte)) then

                    Me => Me%mapaSeguinte

                endif

            endif

        end subroutine

        subroutine viajarAnterior()

            character(len=StringLength) :: nomePais

            if(associated(Me)) then

                nomePais = Me%pais%nome

                call viagemRegresso()

                if (nomePais .ne. Me%pais%nome) then
                
                    do while (  associated(Me%mapaSeguinte)                 &
                                .and.                                       &
                                nomePais .ne. Me%mapaSeguinte%pais%nome)
                    
                            call viajarSeguinte()
                        
                    enddo
                    
                endif

            endif

        end subroutine viajarAnterior

        subroutine criarMapa(mapa, mapaDeCasa)

                type(T_Mapa), pointer :: mapa, mapaDeCasa

                allocate(mapa)

                mapa%mapaDeCasa => mapaDeCasa

        end subroutine criarMapa

        subroutine abandonarNovoMundo
 
                type(T_Mapa), pointer :: mundoAbandonado, novoFimDoMundo

                if (associated(Me)) then

                    call viajarFimDoMundo

                    mundoAbandonado => Me
                    
                    call viajarAnterior
                    
                    novoFimDoMundo => Me
                    
                    if (associated(novoFimDoMundo%mapaSeguinte)) then
                    
                        nullify(novoFimDoMundo%mapaSeguinte)
                        
                    endif

                    call viagemRegresso

                    !Testa se o mundo abandonado é casa...
                    nullify(mundoAbandonado%mapaDeCasa)

                    if (not(associated(Me%mapaDeCasa))) then

                        nullify(Me)

                    endif

                    deallocate(mundoAbandonado)

                    if (not(associated(Me))) then

                        write(*,*) 'Mundo destruido.'

                    endif

                endif

        end subroutine abandonarNovoMundo

        subroutine apocalipse

                do while (associated(Me))

                    call abandonarNovoMundo

                end do

        end subroutine apocalipse

        subroutine verMapaMundo

                call viagemRegresso

                write(*,*) trim(Me%pais%nome)

                do while(associated(Me%mapaSeguinte))

                        Me => Me%mapaSeguinte                        

                        write(*,*) trim(Me%pais%nome)

                end do

        end subroutine verMapaMundo

        subroutine verMapa

                type(T_Mapa), pointer   :: presente

                presente => Me

                call viajarAnterior

                if (Me%pais%nome .ne. presente%pais%nome) then

                    write(*,*) trim(Me%pais%nome)

                else

                    write(*,*) 'Casa.'

                endif

                Me => presente

                write(*,*) trim(Me%pais%nome)

                if (associated(Me%mapaSeguinte)) then

                        write(*,*) trim(Me%mapaSeguinte%pais%nome)

                else
                        
                        write(*,*) 'Fim do Mundo.'

                endif

        end subroutine verMapa

        subroutine procurarMapa(nome)

                character(len=StringLength)     :: nome

                type(T_Mapa), pointer           :: esteMapa => Null()

                Me => Me%mapaDeCasa

                do while(associated(Me%mapaSeguinte))

                        if (trim(nome) .eq. trim(Me%pais%nome)) then

                                esteMapa => Me

                        end if

                        Me => Me%mapaSeguinte

                end do

                if (associated(esteMapa)) then

                        Me => esteMapa

                else

                        Me => Me%mapaDeCasa

                        write(*,*)'Não encontrou mapa de ', trim(nome), '.'
                        write(*,*)'De regresso a casa, a ', trim(Me%pais%capital),' :('
                end if

        end subroutine procurarMapa

        end module moduleMapaMundo
