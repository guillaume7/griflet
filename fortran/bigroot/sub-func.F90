program subfunc

implicit none

real :: a,b,c,root1,root2,bigroot
logical :: realroots
write (*,*) "Hello world!"

write (*,10)
read (*,*) a,b,c

!call solvit(a,b,c,root1,root2,realroots)
!write (*,20) root1,root2
write(*,20) bigroot(a,b,c)

if (realroots) then
        write(*,*) 'Sorry, there are no real roots'
end if        

10 format('Enter 3 coefficients')
!20 format('The roots are ', 2f12.6)
20 format('The biggest root is ', f12.6)
end program subfunc

subroutine solvit(a,b,c,root1,root2,realroots)

!Arguments
real ::a,b,c,root1,root2
logical :: realroots

!Locals
real :: test

!Begin
test = b**2-4*a*c

if(test>=0.0) then
        root1 = (-b + sqrt(test))/(2.0*a)
        root2 = (-b - sqrt(test))/(2.0*a)
        realroots = .true.
else
        realroots = .false.        
end if

return
end subroutine solvit

function bigroot(a,b,c)

!Arguments
real :: a,b,c,bigroot

!Local
real :: root1, root2, test

if(test>=0.0) then
        root1 = (-b + sqrt(test))/(2.0*a)
        root2 = (-b - sqrt(test))/(2.0*a)
        if (root1 .gt. root2) then
                bigroot = root1
        else
                bigroot = root2
        end if
else
        bigroot = -9.0e35
end if

return
end function bigroot
