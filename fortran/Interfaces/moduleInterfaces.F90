        module moduleInterfaces       

        implicit none

        private

        public :: interpolate       
        interface interpolate
                module procedure interpolateReal4
                module procedure interpolateReal8
        end interface interpolate

        contains

        subroutine interpolateReal4(x1,x2,x,y1,y2,y)
                real(4)         :: x1,x2,x,y1,y2,y
                real(4)         :: a
                a = x2 - x1
                y =  (x2 - x) / a * y1 + (x - x1) / a * y2
        end subroutine interpolateReal4

        subroutine interpolateReal8(x1,x2,x,y1,y2,y)
                real(8)         :: x1,x2,x,y1,y2,y
                real(8)         :: a
                a = x2 - x1
                y =  (x2 - x) / a * y1 + (x - x1) / a * y2
        end subroutine interpolateReal8

        end module moduleInterfaces
