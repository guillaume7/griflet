        program progMapaMundo

        use moduleMapaMundo

        implicit none

        integer i

        do i=1,1
            call descobrirNovoMundo()
        enddo
        
        call verMapaMundo

        call abandonarNovoMundo

        pause

        end program progMapaMundo
