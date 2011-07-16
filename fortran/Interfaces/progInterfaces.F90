        program Interfaces

        use moduleInterfaces

        implicit none

        real(4)         :: yR4, xR4, x1R4, x2R4, y1R4, y2R4
        real(8)         :: yR8, xR8, x1R8, x2R8, y1R8, y2R8

        x1R4 = 12.1
        x1R8 = 12.1
        x2R4 = 14
        x2R8 = 14
        y1R4 = 23.3
        y1R8 = 23.3
        y2R4 = 37.4
        y2R8 = 37.4
        xR4 = 13.1
        xR8 = 13.1

        call interpolate(x1R4,x2R4, xR4, y1R4, y2R4, yR4)
        write(*,*) 'A interpolacaodo do real de precisao simples vale ', yR4

        call interpolate(x1R8,x2R8, xR8, y1R8, y2R8, yR8)
        write(*,*) 'A interpolacao do real de dupla precisao vale', yR8

        pause

        end program Interfaces
