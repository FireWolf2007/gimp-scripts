; Volf Alexander
; https://www.wolf-a.ru/
; GNU GPLv2

(define 
	(set-copyright-ev InImage InText InFont InPercent InReserve InOpacity InColorPre InColor InPosition InBlur InFlatten)
	(let*    
		(
			(TheWidth (car (gimp-image-width InImage)))
			(TheHeight (car (gimp-image-height InImage)))
			(Old-FG-Color (car (gimp-palette-get-foreground)))
			(FontSize (/ (* TheHeight InPercent) 100))
			(BlurSize (* FontSize 0.07))
			(text-size (gimp-text-get-extents-fontname InText FontSize PIXELS InFont))
			(text-width (car text-size))
			(text-height (cadr text-size))
			(reserve-width (/ (* TheWidth (+ InReserve 4)) 100))
			(reserve-height (/ (* TheHeight InReserve) 100))
			(text-x 0)
			(text-y 0)
		)

		;Корректировка размера шрифта
		(if 
			(< TheWidth TheHeight) 
			(begin
       				(set! FontSize (/ (* TheWidth InPercent) 100))
				(set! BlurSize (* FontSize 0.07))
				(set! text-size (gimp-text-get-extents-fontname InText FontSize PIXELS InFont))
		        	(set! text-width (car text-size))
				(set! text-height (cadr text-size))
			)
		)
      (cond
        ((= InColorPre 0)
                  (gimp-palette-set-foreground '(0 0 0)))
        ((= InColorPre 240)
                  (gimp-palette-set-foreground '(240 240 240)))
        ((= InColorPre 255)
                  (gimp-palette-set-foreground '(240 240 240)))
        )
        (set! text-x (- TheWidth (+ text-width reserve-width)))
		(set! text-y (- TheHeight (+ text-height reserve-height)))
		(let*
			(
				(TextLayer 
					(car 
						(gimp-text-fontname InImage -1 text-x text-y InText -1 TRUE FontSize PIXELS InFont)
					)
				)
			)
			(gimp-layer-set-opacity TextLayer InOpacity)
			(gimp-context-set-foreground Old-FG-Color)
		)
	)
)

(define (duplicate-layer image layer)
	(let* 
		(
			(dup-layer (car (gimp-layer-copy layer 1)))
		)
		(gimp-image-add-layer image dup-layer 0)
		dup-layer
	)
)

(define 
	(batch800-small-jpgs)
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
				(set-copyright-ev
					image
					"\302\251 Alexander Volf"
					"Easy Street EPS Regular , Semi-Expanded"
					10 2
					50.0 240
					220 "Bottom right"
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
	(batchBlog-small-jpgs)
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
				(set-copyright-ev
					image
					"\302\251 Alexander Volf"
					"Easy Street EPS Regular , Semi-Expanded"
					10 2
					50.0 240
					220 "Bottom right"
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
	(batch700-small-jpgs)
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
				(set-copyright-ev
					image
					"\302\251 Alexander Volf"
					"Easy Street EPS Regular , Semi-Expanded"
					10 2
					50.0 240
					220 "Bottom right"
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
	(batch800nove-small-jpgs)
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
	(batch700nove-small-jpgs)
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
	(batch345nove-small-jpgs)
	(let* 
		(
			(ogheight 345)
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
					(gheight ogheight)
					(gwidth (/ start-width (/ start-height gheight)))

					;(gwidth ogwidth)
					;(gheight (/ start-height (/ start-width gwidth)))
				)
				(if
					(< start-width start-height)
					(begin
						(set! gwidth ogheight)
						(set! gheight (/ start-height (/ start-width gwidth)))
						;(set! gheight ogwidth)
						;(set! gwidth (/ start-width (/ start-height gheight)))
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
	(batch400-small-jpgs)
	(let* 
		(
			(ogwidth 400)
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
				(file-jpeg-save RUN-NONINTERACTIVE image drawable filename filename 1 0 0 0 "Photographer Volf Alexander; gimp@wolf-a.ru" 0 1 0 1)
				(gimp-image-delete image)
			)
           		(set! filelist (cdr filelist))
		)
	)
)


(define 
	(batch1600-small-jpgs)
	(let* 
		(
			(ogwidth 1600)
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
				; копировать слой
				(set! my_layer (duplicate-layer image drawable))
				;изменить размер
				(gimp-image-scale image gwidth (/ start-height (/ start-width gwidth)))
				; unsharp
				;(plug-in-unsharp-mask RUN-NONINTERACTIVE
                                ;	   image my_layer 5.0 0.5 0)
				(plug-in-sharpen RUN-NONINTERACTIVE
					image my_layer 10)
				; прозрачность верхнего слоя 75%
				(gimp-layer-add-alpha my_layer)
				(gimp-layer-set-opacity my_layer 75)
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
	(batch-all-jpgs-ev inColor)
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
				(set-copyright-ev
					image
					"\302\251 Alexander Volf"
					"Easy Street EPS Regular , Semi-Expanded"
					10 2
					80.0 inColor
					220 "Bottom right"
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
	(batch-all-jpgs-ev 0)
)
(define 
	(batch-all-jpgs-evw)
	(batch-all-jpgs-ev 240)
)


(define 
	(batch800-small-jpgs2)
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
				(set-copyright-ev
					image
					"\302\251 Alexander Volf"
					"Easy Street EPS Regular , Semi-Expanded"
					10 2
					50.0 255
					220 "Bottom right"
					FALSE FALSE)
				; объединить и выставить слой drawable
				(gimp-image-merge-visible-layers image 0)
				(set! drawable (car (gimp-image-get-active-layer image)))
              ; поставить копирайт
				(set-copyright-ev
					image
					"\302\251 Alexander Volf"
					"Easy Street EPS Regular , Semi-Expanded"
					10 2
					50.0 0
					220 "Bottom right"
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
	(batchBlog-small-jpgs2)
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
				(set-copyright-ev
					image
					"\302\251 Alexander Volf"
					"Easy Street EPS Regular , Semi-Expanded"
					10 2
					50.0 255
					220 "Bottom right"
					FALSE FALSE)
				; объединить и выставить слой drawable
				(gimp-image-merge-visible-layers image 0)
				(set! drawable (car (gimp-image-get-active-layer image)))
                ; поставить копирайт
				(set-copyright-ev
					image
					"\302\251 Alexander Volf"
					"Easy Street EPS Regular , Semi-Expanded"
					10 2
					50.0 0
					220 "Bottom right"
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