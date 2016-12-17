; Volf Alexander
; https://www.wolf-a.ru/
; GNU GPLv2

(define 
	(batch800-small-jpgsWWW)
	(let* 
		(
			(ogwidth 800)
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
					(my_layer (car (gimp-image-get-active-layer image)))
					(start-width (car (gimp-image-width image)))
					(start-height (car (gimp-image-height image)))
					(gwidth ogwidth)
					(gheight (/ start-height (/ start-width gwidth)))
				)
				(if
					(< start-width start-height)
					(begin
						(set! gheight ogwidth)
						(set! gwidth (/ start-width (/ start-height gheight)))
					)
				)
				;изменить размер
				(gimp-image-scale image gwidth (/ start-height (/ start-width gwidth)))
				; копировать слой
				(set! my_layer (duplicate-layer image drawable))
				; unsharp
				;(plug-in-unsharp-mask RUN-NONINTERACTIVE
				;	image my_layer 5.0 0.5 0)
				(plug-in-sharpen RUN-NONINTERACTIVE
					image my_layer 10)
				; добавить прозрачность
				(gimp-layer-add-alpha my_layer)
				; прозрачность верхнего слоя 50%
				(gimp-layer-set-opacity my_layer 50)
				; объединить и выставить слой drawable
				(gimp-image-merge-visible-layers image 0)
				(set! drawable (car (gimp-image-get-active-layer image)))
				; поставить копирайт
				(script-fu-Eg-Copyright-ev2-all
					image drawable
					"www.wolf-a.ru"
					"Iris"
					6 100.0 220 "Bottom right"
					FALSE FALSE)
				; объединить и выставить слой drawable
				(gimp-image-merge-visible-layers image 0)
				(set! drawable (car (gimp-image-get-active-layer image)))
				(file-jpeg-save RUN-NONINTERACTIVE image drawable filename filename 1 0 0 0 "Photographer Volf Alexander; gimp@wolf-a.ru" 0 1 0 1)
				(gimp-image-delete image)
			)
           		(set! filelist (cdr filelist))
		)
	)
)

(define 
	(batchBlog-small-jpgsWWW)
	(let* 
		(
			(ogwidth 700) 
                        (ogwidth2 345)
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
					(my_layer (car (gimp-image-get-active-layer image)))
					(start-width (car (gimp-image-width image)))
					(start-height (car (gimp-image-height image)))
					(gwidth ogwidth)
					(gheight (/ start-height (/ start-width gwidth)))
				)
				(if
					(< start-width start-height)
					(begin
						(set! gwidth ogwidth2)
						(set! gheight (/ start-height (/ start-width gwidth)))
					)
				)
				;изменить размер
				(gimp-image-scale image gwidth (/ start-height (/ start-width gwidth)))
				; копировать слой
				(set! my_layer (duplicate-layer image drawable))
				; unsharp
				;(plug-in-unsharp-mask RUN-NONINTERACTIVE
				;	image my_layer 5.0 0.5 0)
				(plug-in-sharpen RUN-NONINTERACTIVE
					image my_layer 10)
				; добавить прозрачность
				(gimp-layer-add-alpha my_layer)
				; прозрачность верхнего слоя 50%
				(gimp-layer-set-opacity my_layer 50)
				; объединить и выставить слой drawable
				(gimp-image-merge-visible-layers image 0)
				(set! drawable (car (gimp-image-get-active-layer image)))
				; поставить копирайт
				(script-fu-Eg-Copyright-ev2-all
					image drawable
					"www.wolf-a.ru"
					"Iris"
					6 100.0 220 "Bottom right"
					FALSE FALSE)
				; объединить и выставить слой drawable
				(gimp-image-merge-visible-layers image 0)
				(set! drawable (car (gimp-image-get-active-layer image)))
				(file-jpeg-save RUN-NONINTERACTIVE image drawable filename filename 1 0 1 0 "Photographer Volf Alexander; gimp@wolf-a.ru" 0 1 0 0)
				(gimp-image-delete image)
			)
           		(set! filelist (cdr filelist))
		)
	)
)


(define 
	(batch700-small-jpgsWWW)
	(let* 
		(
			(ogwidth 700)
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
					(my_layer (car (gimp-image-get-active-layer image)))
					(start-width (car (gimp-image-width image)))
					(start-height (car (gimp-image-height image)))
					(gwidth ogwidth)
					(gheight (/ start-height (/ start-width gwidth)))
				)
				(if
					(< start-width start-height)
					(begin
						(set! gheight ogwidth)
						(set! gwidth (/ start-width (/ start-height gheight)))
					)
				)
				;изменить размер
				(gimp-image-scale image gwidth (/ start-height (/ start-width gwidth)))
				; копировать слой
				(set! my_layer (duplicate-layer image drawable))
				; unsharp
				;(plug-in-unsharp-mask RUN-NONINTERACTIVE
				;	image my_layer 5.0 0.5 0)
				(plug-in-sharpen RUN-NONINTERACTIVE
					image my_layer 10)
				; добавить прозрачность
				(gimp-layer-add-alpha my_layer)
				; прозрачность верхнего слоя 50%
				(gimp-layer-set-opacity my_layer 50)
				; объединить и выставить слой drawable
				(gimp-image-merge-visible-layers image 0)
				(set! drawable (car (gimp-image-get-active-layer image)))
				; поставить копирайт
				(script-fu-Eg-Copyright-ev2-all
					image drawable
					"www.wolf-a.ru"
					"Iris"
					6 100.0 220 "Bottom right"
					FALSE FALSE)
				; объединить и выставить слой drawable
				(gimp-image-merge-visible-layers image 0)
				(set! drawable (car (gimp-image-get-active-layer image)))
				(file-jpeg-save RUN-NONINTERACTIVE image drawable filename filename 1 0 0 0 "Photographer Volf Alexander; gimp@wolf-a.ru" 0 1 0 1)
				(gimp-image-delete image)
			)
           		(set! filelist (cdr filelist))
		)
	)
)

(define 
	(batch-all-jpgs-evWWW inColor)
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
					(my_layer (car (gimp-image-get-active-layer image)))
				)
				; поставить копирайт
				(script-fu-Eg-Copyright-ev2-all
					image drawable
					"www.wolf-a.ru"
					"Iris"
					6 100.0 220 "Bottom right"
					FALSE FALSE)
                ; объединить и выставить слой drawable
				(gimp-image-merge-visible-layers image 0)
				(set! drawable (car (gimp-image-get-active-layer image)))
				(file-jpeg-save RUN-NONINTERACTIVE image drawable filename filename 1 0 0 0 "Photographer Volf Alexander; gimp@wolf-a.ru" 0 1 0 1)
				(gimp-image-delete image)
			)
           		(set! filelist (cdr filelist))
		)
	)
)

(define 
	(batch-all-jpgs-evb)
	(batch-all-jpgs-evWWW 0)
)
(define 
	(batch-all-jpgs-evw)
	(batch-all-jpgs-evWWW 240)
)


(define 
	(batch800-small-jpgs2WWW)
	(let* 
		(
			(ogwidth 800)
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
					(my_layer (car (gimp-image-get-active-layer image)))
					(start-width (car (gimp-image-width image)))
					(start-height (car (gimp-image-height image)))
					(gwidth ogwidth)
					(gheight (/ start-height (/ start-width gwidth)))
				)
				(if
					(< start-width start-height)
					(begin
						(set! gheight ogwidth)
						(set! gwidth (/ start-width (/ start-height gheight)))
					)
				)
				;изменить размер
				(gimp-image-scale image gwidth (/ start-height (/ start-width gwidth)))
				; копировать слой
				(set! my_layer (duplicate-layer image drawable))
				; unsharp
				;(plug-in-unsharp-mask RUN-NONINTERACTIVE
				;	image my_layer 5.0 0.5 0)
				(plug-in-sharpen RUN-NONINTERACTIVE
					image my_layer 10)
				; добавить прозрачность
				(gimp-layer-add-alpha my_layer)
				; прозрачность верхнего слоя 50%
				(gimp-layer-set-opacity my_layer 50)
				; объединить и выставить слой drawable
				(gimp-image-merge-visible-layers image 0)
				(set! drawable (car (gimp-image-get-active-layer image)))
				; поставить копирайт
				(script-fu-Eg-Copyright-ev2-all
					image drawable
					"www.wolf-a.ru"
					"Iris"
					6 100.0 220 "Bottom right"
					FALSE FALSE)
				; объединить и выставить слой drawable
				(gimp-image-merge-visible-layers image 0)
				(set! drawable (car (gimp-image-get-active-layer image)))
              ; поставить копирайт
				(script-fu-Eg-Copyright-ev2-all
					image drawable
					"www.wolf-a.ru"
					"Iris"
					6 100.0 220 "Bottom right"
					FALSE FALSE)
				; объединить и выставить слой drawable
				(gimp-image-merge-visible-layers image 0)
				(set! drawable (car (gimp-image-get-active-layer image)))
				(file-jpeg-save RUN-NONINTERACTIVE image drawable filename filename 0.9 0 0 0 "Photographer Volf Alexander; gimp@wolf-a.ru" 0 1 0 1)
				(gimp-image-delete image)
			)
           		(set! filelist (cdr filelist))
		)
	)
)

(define 
	(batchBlog-small-jpgs2WWW)
	(let* 
		(
			(ogwidth 700) 
                        (ogwidth2 345)
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
					(my_layer (car (gimp-image-get-active-layer image)))
					(start-width (car (gimp-image-width image)))
					(start-height (car (gimp-image-height image)))
					(gwidth ogwidth)
					(gheight (/ start-height (/ start-width gwidth)))
				)
				(if
					(< start-width start-height)
					(begin
						(set! gwidth ogwidth2)
						(set! gheight (/ start-height (/ start-width gwidth)))
					)
				)
				;изменить размер
				(gimp-image-scale image gwidth (/ start-height (/ start-width gwidth)))
				; копировать слой
				(set! my_layer (duplicate-layer image drawable))
				; unsharp
				;(plug-in-unsharp-mask RUN-NONINTERACTIVE
				;	image my_layer 5.0 0.5 0)
				(plug-in-sharpen RUN-NONINTERACTIVE
					image my_layer 10)
				; добавить прозрачность
				(gimp-layer-add-alpha my_layer)
				; прозрачность верхнего слоя 50%
				(gimp-layer-set-opacity my_layer 50)
				; объединить и выставить слой drawable
				(gimp-image-merge-visible-layers image 0)
				; объединить и выставить слой drawable
				(gimp-image-merge-visible-layers image 0)
				(set! drawable (car (gimp-image-get-active-layer image)))
				; поставить копирайт
				(script-fu-Eg-Copyright-ev2-all
					image drawable
					"www.wolf-a.ru"
					"Iris"
					6 100.0 220 "Bottom right"
					FALSE FALSE)
				; объединить и выставить слой drawable
				(gimp-image-merge-visible-layers image 0)
				(set! drawable (car (gimp-image-get-active-layer image)))
                ; поставить копирайт
				(script-fu-Eg-Copyright-ev2-all
					image drawable
					"www.wolf-a.ru"
					"Iris"
					6 100.0 220 "Bottom right"
					FALSE FALSE)
				; объединить и выставить слой drawable
				(gimp-image-merge-visible-layers image 0)
				(set! drawable (car (gimp-image-get-active-layer image)))
				(file-jpeg-save RUN-NONINTERACTIVE image drawable filename filename 1 0 1 0 "Photographer Volf Alexander; gimp@wolf-a.ru" 0 1 0 0)
				(gimp-image-delete image)
			)
           		(set! filelist (cdr filelist))
		)
	)
)