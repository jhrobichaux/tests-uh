!
!
! Copyright (c) 2011 - 2015
!   University of Houston System and UT-Battelle, LLC.
! Copyright (c) 2009 - 2015
!   Silicon Graphics International Corp.  SHMEM is copyrighted
!   by Silicon Graphics International Corp. (SGI) The OpenSHMEM API
!   (shmem) is released by Open Source Software Solutions, Inc., under an
!   agreement with Silicon Graphics International Corp. (SGI).
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
! o Neither the name of the University of Houston System, UT-Battelle, LLC
!   nor the names of its contributors may be used to endorse or promote
!   products derived from this software without specific prior written
!   permission.
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

program test_shmem_accessible
  implicit none
  include 'shmem.fh'
  integer, parameter    :: length = 4

  character, ALLOCATABLE :: remote_dest(:)

  integer               :: me, npes, errcode

  ! SHMEM function definitions
  integer               :: shmem_my_pe, shmem_n_pes
  ! --

  call shmem_init()

  me   = shmem_my_pe()
  npes = shmem_n_pes()

  if(npes .lt. 2 ) then
    write(*,*) 'This test requires 2+ PEs to run.'
    stop
  end if

  allocate(remote_dest(length), STAT=errcode);

  if(errcode .ne. 0) then
    write(*,*) 'Unable to allocate symmetric memory for the test.'
    stop
  end if

  call shmem_barrier_all()

  if (me .eq. 0) then
    if(.not.shmem_addr_accessible(remote_dest, 1) ) then
      write(*,*) 'test_shmem_acc_mem_05_character: Passed'
    else
      write(*,*) 'test_shmem_acc_mem_05_character: Failed'
    end if
  end if

  call shmem_barrier_all()

  deallocate(remote_dest)

  call shmem_finalize()

end program test_shmem_accessible
