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
