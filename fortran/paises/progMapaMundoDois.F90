        program progMapaMundoDois

        use moduleMapaMundoDois

        implicit none

        integer                 :: i

        !Inovação: destruamos o Me e conseguiremos
        !criar naturalmente várias instâncias de
        !atlases (ou colecções de mapas).

        type(T_Mapa), pointer   :: mapaTerrestre  => Null()

        type(T_Mapa), pointer   :: mapaLunar      => Null()

        !Descobrir e explorar a Terra

        do i=1,2

            call descobrirNovoMundo(mapaTerrestre)

        enddo
        
        call verMapaMundo(mapaTerrestre)

        call apocalipse(mapaTerrestre)

        !Descobrir e explorar a Lua

        call descobrirNovoMundo(mapaLunar)

        call verMapa(mapaLunar)
        
        call apocalipse(mapaLunar)

        pause

        end program progMapaMundoDois
