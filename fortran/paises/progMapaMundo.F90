        program progMapaMundo

        use moduleMapaMundo

        implicit none

        integer i

        do i=1,3
            call descobrirNovoMundo()
        enddo
        
        call verMapaMundo

        call apocalipse

        pause

        end program progMapaMundo
