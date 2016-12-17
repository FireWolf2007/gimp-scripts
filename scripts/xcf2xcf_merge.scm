; Volf Alexander
; https://www.wolf-a.ru/
; GNU GPLv2

(define 
	(batch-xcf-to-xcf-merge)
	(let* 
		(
			(pattern "*.[xX][cC][fF]")
			(filelist (cadr (file-glob pattern 1)))
		)
		(while
			(not (null? filelist))
			(let* 
				(
					(filename (car filelist))
					(image (car (gimp-file-load RUN-NONINTERACTIVE filename filename)))
					(drawable (car (gimp-image-get-active-layer image)))
				)
              (gimp-image-merge-visible-layers image 0)
              (set! drawable (car (gimp-image-get-active-layer image)))
              (gimp-xcf-save RUN-NONINTERACTIVE image drawable filename filename)
              (gimp-image-delete image)
            )
           	(set! filelist (cdr filelist))
		)
	)
)
