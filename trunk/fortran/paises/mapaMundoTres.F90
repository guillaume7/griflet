        module moduleMapaMundoTres

        implicit none

        integer, parameter  :: StringLength = 128
       
        type C_Colecao
                integer                         :: id
                class(C_Colecao), pointer       :: objectoAnterior
                class(C_Colecao), pointer       :: objectoSeguinte
        contains
                procedure                       :: viajaAnterior
                procedure                       :: viajaSeguinte
        end type C_Colecao

        type, public :: T_Pais
                character(len=StringLength) :: nome
                character(len=StringLength) :: capital
                real                        :: pop
                real                        :: pib
        contains
                procedure :: fundar     => fundarPais
                procedure :: explorar   => explorarPais
        end type T_Pais

        public :: T_Mapa
        type T_Mapa
                type(T_Pais)            :: pais
                type(T_Mapa), pointer   :: mapaDeCasa => Null()
                type(T_Mapa), pointer   :: mapaSeguinte => Null()
        end type T_Mapa

        contains

        subroutine fundarPais(pais)

                type(T_Pais) :: pais

                write(*,*) 'Descoberta dum novo Mundo:'

                write(*,*) ''

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

        subroutine descobrirNovoMundo(Me)

                type(T_Mapa), pointer   :: Me

                !Se o mapa ainda não existe, então é criado
                if (.not. associated(Me)) then

                        call criarMapa(Me,Me)

                !Senão o Atlas é incrementado
                else

                        call viajarFimDoMundo(Me)

                        call criarMapa(Me%mapaSeguinte, Me%mapaDeCasa)

                        Me => Me%mapaSeguinte

                end if

                call fundarPais(Me%pais)

        end subroutine descobrirNovoMundo

        subroutine viajarFimDoMundo(Me)

                type(T_Mapa), pointer   :: Me

                do while (associated(Me%mapaSeguinte))

                        Me => Me%mapaSeguinte

                end do  

        end subroutine viajarFimDoMundo

        subroutine viagemRegresso(Me)

                type(T_Mapa), pointer   :: Me

                if(associated(Me)) then

                    Me => Me%mapaDeCasa

                endif

        end subroutine viagemRegresso
        
        subroutine viajarSeguinte(Me)

            type(T_Mapa), pointer   :: Me

            if(associated(Me)) then

                if(associated(Me%mapaSeguinte)) then

                    Me => Me%mapaSeguinte

                endif

            endif

        end subroutine

        subroutine viajarAnterior(Me)

            type(T_Mapa), pointer   :: Me

            character(len=StringLength) :: nomePais

            if(associated(Me)) then

                nomePais = Me%pais%nome

                call viagemRegresso(Me)

                if (nomePais .ne. Me%pais%nome) then
                
                    do while (  associated(Me%mapaSeguinte)                 &
                                .and.                                       &
                                nomePais .ne. Me%mapaSeguinte%pais%nome)
                    
                            call viajarSeguinte(Me)
                        
                    enddo
                    
                endif

            endif

        end subroutine viajarAnterior

        subroutine criarMapa(mapa, mapaDeCasa)

                type(T_Mapa), pointer :: mapa, mapaDeCasa

                allocate(mapa)

                mapa%mapaDeCasa => mapaDeCasa

        end subroutine criarMapa

        subroutine abandonarNovoMundo(Me)
 
                type(T_Mapa), pointer :: Me, mundoAbandonado, novoFimDoMundo

                if (associated(Me)) then

                    call viajarFimDoMundo(Me)

                    mundoAbandonado => Me
                    
                    call viajarAnterior(Me)
                    
                    novoFimDoMundo => Me
                    
                    if (associated(novoFimDoMundo%mapaSeguinte)) then
                    
                        nullify(novoFimDoMundo%mapaSeguinte)
                        
                    endif

                    call viagemRegresso(Me)

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

        subroutine apocalipse(Me)

                type(T_Mapa), pointer   :: Me

                do while (associated(Me))

                    call abandonarNovoMundo(Me)

                end do
                        
                write(*,*) ''

        end subroutine apocalipse

        subroutine verMapaMundo(Me)

                type(T_Mapa), pointer   :: Me

                write(*,*) 'Vista do mapa-mundo:'

                write(*,*) ''

                call viagemRegresso(Me)

                write(*,*) trim(Me%pais%nome)

                do while(associated(Me%mapaSeguinte))

                        Me => Me%mapaSeguinte                        

                        write(*,*) trim(Me%pais%nome)

                end do

                write(*,*) ''

        end subroutine verMapaMundo

        subroutine verMapa(Me)

                type(T_Mapa), pointer   :: Me, presente

                write(*,*) 'Vista do mapa:'

                write(*,*) ''

                presente => Me

                call viajarAnterior(Me)

                if (Me%pais%nome .ne. presente%pais%nome) then

                    write(*,*) trim(Me%pais%nome)

                else

                    write(*,*) 'Casa'

                endif

                Me => presente

                write(*,*) trim(Me%pais%nome)

                if (associated(Me%mapaSeguinte)) then

                        write(*,*) trim(Me%mapaSeguinte%pais%nome)

                else
                        
                        write(*,*) 'Fim do Mundo'

                endif
                        
                write(*,*) ''

        end subroutine verMapa

        subroutine procurarMapa(Me, nome)

                character(len=StringLength)     :: nome

                type(T_Mapa), pointer   :: Me

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

        end module moduleMapaMundoTres

!----------------- Programa ----------------------

        program progMapaMundoTres

        use moduleMapaMundoTres

        implicit none

        integer                 :: i

        !Inovação: destruamos o Me e conseguiremos
        !criar naturalmente várias instâncias de
        !atlases (ou colecções de mapas).

        type(T_Mapa), pointer   :: mapaTerrestre  => Null()

        type(T_Mapa), pointer   :: mapaLunar      => Null()

        !Descobrir e explorar a Terra

        do i=1,2

            call mapaTerrestre%descobrirNovoMundo

        enddo
        
        call mapaTerrestre%verMapaMundo

        call mapaTerrestre%apocalipse

        !Descobrir e explorar a Lua

        call mapaLunar%descobrirNovoMundo

        call mapaLunar%verMapa
        
        call mapaLunar%apocalipse

        pause

        end program progMapaMundoTres
