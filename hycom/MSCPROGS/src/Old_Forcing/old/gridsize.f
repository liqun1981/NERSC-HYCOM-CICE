      subroutine gridsize
c --- --------------------------------------------------------
c --- Computes/load the Coriolis parameter and estimates the
c --- grid size parameters.
c --- 
c --- The Coriolis parameter is stored in corio(udm,jdm)
c --- scux:    zonal grid distance at u-point
c --- scuy:    meridional grid distance at u-point
c --- scvx:    zonal grid distance at v-point
c --- scvy:    meridional grid distance at v-point
c --- scpx:    zonal grid distance at p-point
c --- scpy:    meridional grid distance at p-point
c --- scqx:    zonal grid distance at q-point (vorticity)
c --- scqy:    meridional grid distance at q-point
c --- scXXi:   Inverse of scXX
c --- scp2=scpx*scpy
c --- scp2i= 1/scp2
c --- scu2 = scux*scuy
c --- scv2 = scvx*scvy
c --- scq2i = 1/(scqx*scqy) !Only used once in this form
c ---
c --- --------------------------------------------------------

      INCLUDE 'dimensions.h'
      INCLUDE 'common_blocks.h'

      common/linepr/lp

      REAL plat(0:idm+1,0:jdm+1),plon(0:idm+1,0:jdm+1)           !pos in pressure point   
     .    ,qlat(0:idm+1,0:jdm+1),qlon(0:idm+1,0:jdm+1)           !pos in vorticity point
     .    ,ulat(0:idm+1,0:jdm+1),ulon(0:idm+1,0:jdm+1)           !pos in u-points 
     .    ,vlat(0:idm+1,0:jdm+1),vlon(0:idm+1,0:jdm+1)           !pos in v-points
     .    ,spherdist,dsmax,dtmax,gh,dl
  

      REAL scqx,scqy,gdist,realat,unit,r3,scale,dd

      INTEGER nx,ny,im,jm,lp,iutil(idm,jdm,12)
     .        ,i0,j0 

      LOGICAL gdiag,tdiag
 
      CHARACTER*80    gridid
      CHARACTER*4 wgrid
c
      INCLUDE 'stmt_functions.h'


c --- ---------------------------------------------------------

c      gdist=.25*111.2E5          !Griddistance (cm)
      gdist=3.0E5  !3km       !Griddistance (cm)
      unit=100.                  !Unit=100 (cm), unit=1 m  

                                 !What grid:  
      wgrid='merc'               ! Mercator
c      wgrid='file'               ! Positions from file
c      wgrid='eqvi'               ! Const. grid distance 


      tdiag=.FALSE.              !Do not dump in Tecplot format
      gdiag=.FALSE.              !Do not show masks 

c      gdiag=.TRUE.               !Show masks
c      tdiag=.TRUE.               !Dump in Tecplot format

      WRITE(*,*)'------ In rutine gridsize.f ------'
c
      IF(wgrid.EQ.'file')THEN
c --- ------------------------------------------------------------------
c --- load grid positions from file
c --- ------------------------------------------------------------------
      WRITE(*,*)'Load grid positions from file: latlon.dat'
c
      open(73,file='latlon.dat',form='formatted')
      READ(73,'(2i5)',ERR=250)nx,ny
      write(*,*)nx,ny
      IF(nx.NE.idm.OR.ny.NE.jdm)THEN
        WRITE(*,*)'Mismatch between lat-lon file dimension'
        WRITE(*,*)'and model dimension. I quit!!!!'
        CLOSE(73)
        STOP'Error'
      ENDIF
c
      read(73,'(a80)')gridid
      read(73,'(15e14.7)')((qlat(i,j),i=1,idm),j=1,jdm)
      read(73,'(15e14.7)')((qlon(i,j),i=1,idm),j=1,jdm)
      read(73,'(15e14.7)')((plat(i,j),i=0,idm),j=0,jdm)
      read(73,'(15e14.7)')((plon(i,j),i=0,idm),j=0,jdm)
      read(73,'(15e14.7)')((ulat(i,j),i=1,idm),j=0,jdm)
      read(73,'(15e14.7)')((ulon(i,j),i=1,idm),j=0,jdm)
      read(73,'(15e14.7)')((vlat(i,j),i=0,idm),j=1,jdm)
      read(73,'(15e14.7)')((vlon(i,j),i=0,idm),j=1,jdm)
      close(73)
c
c --- ------------------------------------------------------------------
c --- extends the grid arrays to i=0, i=idm+1, j=0, j=jdm+1
c --- note: corner points are not updated
c --- ------------------------------------------------------------------
c
      do 51 j=1,jdm
c qlat
      diffl=qlat(2,j)  -qlat(1,j)
      diffr=qlat(idm,j)-qlat(idm-1,j)
      qlat(0,j)    =qlat(1,j)  -diffl
      qlat(idm+1,j)=qlat(idm,j)+diffr
c qlon
      diffl=qlon(2,j)  -qlon(1,j)
      diffr=qlon(idm,j)-qlon(idm-1,j)
      qlon(0,j)    =qlon(1,j)  -diffl
      qlon(idm+1,j)=qlon(idm,j)+diffr
c plat
      diffr=plat(idm,j)-plat(idm-1,j)
      plat(idm+1,j)=plat(idm,j)+diffr
c plon
      diffr=plon(idm,j)-plon(idm-1,j)
      plon(idm+1,j)=plon(idm,j)+diffr
c ulat
      diffl=ulat(2,j)  -ulat(1,j)
      diffr=ulat(idm,j)-ulat(idm-1,j)
      ulat(0,j)    =ulat(1,j)  -diffl
      ulat(idm+1,j)=ulat(idm,j)+diffr
c ulon
      diffl=ulon(2,j)  -ulon(1,j)
      diffr=ulon(idm,j)-ulon(idm-1,j)
      ulon(0,j)    =ulon(1,j)  -diffl
      ulon(idm+1,j)=ulon(idm,j)+diffr
c vlat
      diffr=vlat(idm,j)-vlat(idm-1,j)
      vlat(idm+1,j)=vlat(idm,j)+diffr
c vlon
      diffr=vlon(idm,j)-vlon(idm-1,j)
      vlon(idm+1,j)=vlon(idm,j)+diffr
   51 continue
c
c ---
c
      do 52 i=1,idm
c qlat
      diffu=qlat(i,2)  -qlat(i,1)
      diffo=qlat(i,jdm)-qlat(i,jdm-1)
      qlat(i,0)    =qlat(i,1)  -diffu
      qlat(i,jdm+1)=qlat(i,jdm)+diffo
c qlon
      diffu=qlon(i,2)  -qlon(i,1)
      diffo=qlon(i,jdm)-qlon(i,jdm-1)
      qlon(i,0)    =qlon(i,1)  -diffu
      qlon(i,jdm+1)=qlon(i,jdm)+diffo
c plat
      diffo=plat(i,jdm)-plat(i,jdm-1)
      plat(i,jdm+1)=plat(i,jdm)+diffo  
c plon
      diffo=plon(i,jdm)-plon(i,jdm-1)
      plon(i,jdm+1)=plon(i,jdm)+diffo  
c ulat
      diffo=ulat(i,jdm)-ulat(i,jdm-1)
      ulat(i,jdm+1)=ulat(i,jdm)+diffo  
c ulon
      diffo=ulon(i,jdm)-ulon(i,jdm-1)
      ulon(i,jdm+1)=ulon(i,jdm)+diffo  
c vlat
      diffu=vlat(i,2)  -vlat(i,1)
      diffo=vlat(i,jdm)-vlat(i,jdm-1)
      vlat(i,0)    =vlat(i,1)  -diffu  
      vlat(i,jdm+1)=vlat(i,jdm)+diffo  
c vlon
      diffu=vlon(i,2)  -vlon(i,1)
      diffo=vlon(i,jdm)-vlon(i,jdm-1)
      vlon(i,0)    =vlon(i,1)  -diffu  
      vlon(i,jdm+1)=vlon(i,jdm)+diffo  
   52 continue
c
c --- ------------------------------------------------------------------
c --- define gridsize at u, v, p, and q points
c ---
c --- stencil:    - o    or    u p      
c ---             x |          q v
c ---
c --- ------------------------------------------------------------------
c 
      do 200 i=1,idm
      im1=i-1
      ip1=i+1
c
      do 200 j=1,jdm
      jm1=j-1
      jp1=j+1
c
      scux(i,j)=unit*
     .      spherdist(plon(i,j)   ,plat(i,j),
     .                plon(im1,j) ,plat(im1,j))
c
      scuy(i,j)=unit*
     .      spherdist(qlon(i,jp1),qlat(i,jp1),
     .                qlon(i,j)  ,qlat(i,j))
c
      scvx(i,j)=unit*
     .      spherdist(qlon(i,jp1),qlat(i,jp1),
     .                qlon(i,j)  ,qlat(i,j))
c
      scvy(i,j)=unit*
     .      spherdist(plon(i,j)   ,plat(i,j),
     .                plon(i,jm1) ,plat(i,jm1))
c
      scpx(i,j)=unit*
     .      spherdist(ulon(ip1,j) ,ulat(ip1,j),
     .                ulon(i,j)   ,ulat(i,j))
c
      scpy(i,j)=unit*
     .      spherdist(vlon(i,jp1),vlat(i,jp1), 
     .                vlon(i,j)  ,vlat(i,j))
c
      scqx=unit*                                 !never used in model
     .      spherdist(vlon(i,j)   ,vlat(i,j),
     .                vlon(im1,j) ,vlat(im1,j))
c
      scqy=unit*                                 !never used in model
     .      spherdist(ulon(i,j)   ,ulat(i,j),
     .                ulon(i,jm1) ,ulat(i,jm1))
c        
      scuxi(i,j)=1./scux(i,j)
      scuyi(i,j)=1./scuy(i,j)
      scvxi(i,j)=1./scvx(i,j)
      scvyi(i,j)=1./scvy(i,j)
      scpxi(i,j)=1./scpx(i,j)
      scpyi(i,j)=1./scpy(i,j)
c
      scu2n(i,j)=scux(i,j)*scuy(i,j)
      scv2n(i,j)=scvy(i,j)*scvx(i,j)
      scp2n(i,j)=scpx(i,j)*scpy(i,j)
      scp2in(i,j)=1./scp2n(i,j)
      scq2in(i,j)=1./(scqx*scqy)

  200 rlat(i,j)=plat(i,j)/radian                 !latitudes (in rad) for export 
c
c --- define coriolis parameter on vorticity points
c 
      const=4.*pi/86400.
      do 201 i=1,idm
      do 201 j=1,jdm
      realat=qlat(i,j)/radian
  201 corio(i,j)=sin(realat)*const
c ---
      ENDIF !file

c ---  ----------------------------------------------------------
      IF(wgrid.EQ.'eqvi')THEN
      WRITE(*,*)'Constant grid distance equal to  (m)',gdist*.01
c --- ---------------------------------- Equal dist. grid  --------------
       DO i0=0,idm+1
        i=MAX(1,MIN(i0,idm))
        im=MAX(i-1,1)
 
        DO j0=0,jdm+1
         j=MAX(1,MIN(j0,jdm))
         jm=MAX(j-1,1)
 
         scux(i0,j0)=gdist   
         scuy(i0,j0)=gdist
         scvx(i0,j0)=gdist
         scvy(i0,j0)=gdist
         scpx(i0,j0)=gdist
         scpy(i0,j0)=gdist
         scqx=gdist
         scqy=gdist

         scuxi(i0,j0)=1./MAX(scux(i0,j0),1.)
         scuyi(i0,j0)=1./MAX(scuy(i0,j0),1.)
         scvxi(i0,j0)=1./MAX(scvx(i0,j0),1.)
         scvyi(i0,j0)=1./MAX(scvy(i0,j0),1.)
         scpxi(i0,j0)=1./MAX(scpx(i0,j0),1.)
         scpyi(i0,j0)=1./MAX(scpy(i0,j0),1.)
 
         scu2n(i0,j0)=scux(i0,j0)*scuy(i0,j0)
         scv2n(i0,j0)=scvy(i0,j0)*scvx(i0,j0)
         scp2n(i0,j0)=scpx(i0,j0)*scpy(i0,j0)
         scp2in(i0,j0)=1./scp2n(i0,j0)
         scq2in(i0,j0)=1./MAX(scqx*scqy,1.)
                                          !Lat of voticity point
         qlat(i,j)=61.   
         rlat(i,j)=qlat(i,j)/radian       !Lat of pressure point
        ENDDO
c        write(lp,'(i3,3f8.1)')
c     &     i,scux(i,9)*1.E-5,scvx(i,9)*1.E-5,scpx(i,9)*1.E-5
       ENDDO
       WRITE(*,*)'Const lat: ', qlat(ii/2,jj/2)
c --- ----------------------------- Define coriolis parameter --
c ---                               In vorticity point ---------

      DO i=1,idm
       DO j=1,jdm
        realat=qlat(i,j)/radian
        corio(i,j)=sin(realat)*4.*pi/86400.
       ENDDO
      ENDDO
c ---
      ENDIF

      IF(wgrid.EQ.'merc')THEN
       WRITE(*,*)'Mercator projection. '
       WRITE(*,*)'Parameters in blkdat.f are: '
       WRITE(*,*)'xpivn: ',xpivn,' gridn: ',gridn
       
c --- --------------------------------- Mercator grid ------
       DO i0=0,idm+1
        i=MAX(1,MIN(i0,idm))
        im=MAX(i-1,1)
 
        DO j0=0,jdm+1
         j=MAX(1,MIN(j0,jdm))
         jm=MAX(j-1,1)
 
         scux(i0,j0)=111.2e5 *(alat(xpivn-(i0-1.),gridn)
     .               -alat(xpivn-(i0   ),gridn))*radian
         scuy(i0,j0)=scux(i0,j0)


         scvy(i0,j0)=111.2e5*(alat(xpivn-(i0-.5),gridn)
     .               -alat(xpivn-(i0+.5),gridn))*radian
         scvx(i0,j0)=scvy(i0,j0)

         scpx(i0,j0)=scvy(i0,j0)
         scpy(i0,j0)=scpx(i0,j0)
         scqx=scux(i0,j0)
         scqy=scuy(i0,j0)

         scuxi(i0,j0)=1./MAX(scux(i0,j0),1.)
         scuyi(i0,j0)=1./MAX(scuy(i0,j0),1.)
         scvxi(i0,j0)=1./MAX(scvx(i0,j0),1.)
         scvyi(i0,j0)=1./MAX(scvy(i0,j0),1.)
         scpxi(i0,j0)=1./MAX(scpx(i0,j0),1.)
         scpyi(i0,j0)=1./MAX(scpy(i0,j0),1.)
 

         scu2n(i0,j0)=scux(i0,j0)*scuy(i0,j0)
         scv2n(i0,j0)=scvy(i0,j0)*scvx(i0,j0)
         scp2n(i0,j0)=scpx(i0,j0)*scpy(i0,j0)
         scp2in(i0,j0)=1./scp2n(i0,j0)
         scq2in(i0,j0)=1./MAX(scqx*scqy,1.)
                                              !Lat of voticity point
         qlat(i,j)=alat(xpivn-float(i)+.5,gridn) 
                                              !Lat of pressure point
         rlat(i,j)=alat(xpivn-float(i),gridn) !*radian  
         
        ENDDO
       ENDDO
c ---
        write(lp,'(''Lat in the corners'' ,4f8.1)')
     .  qlat(1,jj),qlat(1,jj),qlat(ii,1),qlat(ii,1)
c --- ----------------------------- Define coriolis parameter --
c ---                               In vorticity point ---------

       DO i=1,idm
        DO j=1,jdm
         realat=qlat(i,j)
         corio(i,j)=sin(realat)*4.*pi/86400.
        ENDDO
       ENDDO
c ---
      ENDIF

c
c --- ------------------------- Compute area of model domain----------
c
      area=0.
c
      do 57 j=1,jj1
      do 57 l=1,isp(j)
      do 57 i=ifp(j,l),ilp(j,l)
        gh=SQRT(100.*depths(i,j)*g)     !Sqrt(gh) (cgs)
        dl=MAX(scpx(i,j),scpy(i,j)) 
        dtmax=dl*1.41/gh
 
        IF(batrop.GT.dtmax)THEN
         write(*,*)'barotp stab cond violated in (i,j)',i,j
         write(*,*)'max dt=',dtmax,' batrop= ',batrop
        ENDIF

        dsmax=gh/ABS(corio(i,j))
        IF(dl.GT.dsmax)THEN
         WRITE(*,*)'dx or dy > sqrt(gh)/f in (i,j)',i,j
 
        ENDIF


 57   area=area+scp2n(i,j)
      write(lp,'(''Area of the model domain (km^2):'',e9.2)')
     & area*1.E-10


c --- diagnostics

      scale=1.E-6        !Output in 10 km 
      IF(gdiag)THEN
       dd=0.000000000
       CALL showmsk(rlat,1,idm,jdm,dd,1.000,
     &             'Lat. (Rad N)           ')
       dd=18.00000000
       CALL showmsk(plon,1,idm,jdm,dd,0.100,
     &             'Lon. (Deg E 0-360)  ')
       dd=0.000000000
       CALL showmsk(scpx,0,idm+1,jdm+1,dd,scale,'scpx (10 km)        ')
       CALL showmsk(scpy,0,idm+1,jdm+1,dd,scale,'scpy (10 km)        ')
       CALL showmsk(scux,0,idm+1,jdm+1,dd,scale,'scux (10 km)        ')
       CALL showmsk(scuy,0,idm+1,jdm+1,dd,scale,'scuy (10 km)        ')
       CALL showmsk(scvx,0,idm+1,jdm+1,dd,scale,'scvx (10 km)        ')
       CALL showmsk(scvy,0,idm+1,jdm+1,dd,scale,'scvy (10 km)        ')
      ENDIF

c                                  !For tecplot &
      IF(tdiag)THEN
       scale=1.E-5        !Output in  km 
       WRITE(1,*)'TITLE=""'
       WRITE(1,*)'VARIABLES=i,j,plon,plat,scux,scuy,scvx,scvy,scpx,scpy'
       WRITE(1,*)'ZONE I=',idm,',J=',jdm,',F=BLOCK'
       WRITE(1,101)((i,i=1,idm),j=1,jdm)
       WRITE(1,101)((j,i=1,idm),j=1,jdm)
       WRITE(1,100)((plon(i,j),i=1,idm),j=1,jdm)
       WRITE(1,100)((plat(i,j),i=1,idm),j=1,jdm)
       WRITE(1,100)((scale*scux(i,j),i=1,idm),j=1,jdm)
       WRITE(1,100)((scale*scuy(i,j),i=1,idm),j=1,jdm)
       WRITE(1,100)((scale*scvx(i,j),i=1,idm),j=1,jdm)
       WRITE(1,100)((scale*scvy(i,j),i=1,idm),j=1,jdm)
       WRITE(1,100)((scale*scpx(i,j),i=1,idm),j=1,jdm)
       WRITE(1,100)((scale*scpy(i,j),i=1,idm),j=1,jdm)
      ENDIF
 100  FORMAT(10(1x,e12.6)) 
 101  FORMAT(30i4)
 
      GOTO 900
 250  WRITE(*,*)'I can not read the file, Sorry'
      STOP'gridsize'
 900  RETURN
      END 




