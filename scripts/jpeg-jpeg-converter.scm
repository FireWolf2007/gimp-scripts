; Volf Alexander
; https://www.wolf-a.ru/
; GNU GPLv2

(define 
	(batch-jpgs-to-jpgs)
	(let* 
		(
			(pattern "*.[jJ][pP][gG]")
			(filelist (cadr (file-glob pattern 1)))
		)
		(while 
			(not (null? filelist))
			(let* 
				(
					(filename (car filelist))
					(image (car (gimp-file-load RUN-NONINTERACTIVE filename filename)))
					(drawable (car (gimp-image-get-active-layer image)))
                    (jpg_filename (string-append (substring filename 0 (- (string-length filename) 4)) ".jpg"))
				)
				(file-jpeg-save RUN-NONINTERACTIVE image drawable jpg_filename jpg_filename 0.9 0 0 0 "Photographer Volf Alexander; gimp@wolf-a.ru" 0 1 0 1)
				(gimp-image-delete image)
			)
           		(set! filelist (cdr filelist))
		)
	)
)
