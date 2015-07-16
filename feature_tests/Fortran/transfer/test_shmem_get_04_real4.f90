!
!
! Copyright (c) 2011 - 2015
!   University of Houston System and UT-Battelle, LLC.
! 
! All rights reserved.
! 
! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions
! are met:
! 
! o Redistributions of source code must retain the above copyright notice,
!   this list of conditions and the following disclaimer.
! 
! o Redistributions in binary form must reproduce the above copyright
!   notice, this list of conditions and the following disclaimer in the
!   documentation and/or other materials provided with the distribution.
! 
! o Neither the name of the University of Houston System, Oak Ridge
!   National Laboratory nor the names of its contributors may be used to
!   endorse or promote products derived from this software without specific
!   prior written permission.
! 
! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
! "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
! LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
! A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
! HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
! SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
! TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
! PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
! LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
! NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
! SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
!
!

program test_shmem_get
  implicit none
  include 'shmem.fh'

  integer, parameter :: N = 7

  integer          ::  i,j
  integer          ::  nextpe
  integer          ::  me, npes
  logical          ::  success1

  real*4          :: dest(N)

  real*4          :: src(N)

  integer          :: errcode, abort

! Function definitions
  integer                   :: shmem_my_pe, shmem_n_pes

  common /globalvars/ src

  call shmem_init()
  
  me   = shmem_my_pe()
  npes = shmem_n_pes()

  if(npes .gt. 1) then

    success1 = .TRUE.
    
    do i = 1, N, 1
      dest(i) = -9
    end do 

    do i = 1, N, 1
      src(i) = REAL(54321 + i, KIND=4)
    end do 

    nextpe = mod((me + 1), npes)

    call shmem_barrier_all()

    call shmem_real_get(dest, src, 0, nextpe)

    call shmem_barrier_all()

    if(me .eq. 0) then
      do i = 1, N, 1
        if(dest(i) .ne. -9) then
          success1 = .FALSE.
        end if
      end do 

      if (success1 .eqv. .TRUE.) then
        write(*,*) "Test shmem_real_get: Failed" 
      else
        write(*,*) "Test shmem_real_get: Passed"
      end if
    end if 

    call shmem_barrier_all()

  else
    write(*,*) "Number of PEs must be > 1 to test shmem get, test skipped"
  end if

  call shmem_finalize()

end program
