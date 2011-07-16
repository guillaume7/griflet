program doloops

implicit none

integer         :: i, n

write (*,*) 'Enter an integer'
read (*,*) n

do i=n,1,-1

      write (*,*) 'Counting pair ', i*2

end do

end program doloops
