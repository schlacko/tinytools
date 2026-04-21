#!/usr/bin/env python3
import sys
import fitz
import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, Gdk, GdkPixbuf

# ---------------- PDF argument ----------------
if len(sys.argv) < 2:
    print("Használat: python3 main.py <pdf_fájl>")
    sys.exit(1)

PDF_FILE = sys.argv[1]

# ---------------- Render ----------------
def render_page(doc, index, target_width=None, target_height=None):
    if index is None or index < 0 or index >= len(doc):
        return None
    page = doc[index]

    # Scaling a kívánt ablakmérethez
    zoom_x = zoom_y = 1.0
    if target_width and target_height:
        page_rect = page.rect
        zoom_x = target_width / page_rect.width
        zoom_y = target_height / page_rect.height
        zoom = min(zoom_x, zoom_y)
    else:
        zoom = 2.0  # default

    mat = fitz.Matrix(zoom, zoom)
    pix = page.get_pixmap(matrix=mat)
    img = GdkPixbuf.Pixbuf.new_from_data(
        pix.samples,
        GdkPixbuf.Colorspace.RGB,
        pix.alpha,
        8,
        pix.width,
        pix.height,
        pix.stride
    )
    return img

# ---------------- Window ----------------
class SlideWindow(Gtk.Window):
    def __init__(self, title=None, borderless=False, monitor_index=0, width=1024, height=768):
        super().__init__(title=title)
        if borderless:
            self.set_decorated(False)
        self.set_default_size(width, height)

        display = Gdk.Display.get_default()
        monitor = display.get_monitor(monitor_index)
        if monitor:
            geom = monitor.get_geometry()
            self.move(geom.x + 50, geom.y + 50)

        self.image = Gtk.Image()
        self.add(self.image)
        self.show_all()

        # Késleltetett első render az ablak méret-allokáció után
        self.connect("size-allocate", self.on_size_allocate_first)
        self._first_render_done = False
        self.controller = None  # később hozzárendeljük

    def on_size_allocate_first(self, widget, allocation):
        if self._first_render_done:
            return
        self._first_render_done = True
        if self.controller:
            self.controller.update_windows()

    def show_page(self, pixbuf):
        if pixbuf:
            alloc = self.get_allocation()
            if alloc.width > 0 and alloc.height > 0:
                scaled = pixbuf.scale_simple(alloc.width, alloc.height, GdkPixbuf.InterpType.BILINEAR)
                self.image.set_from_pixbuf(scaled)
        else:
            self.image.clear()

# ---------------- Controller ----------------
class SlideController:
    def __init__(self, doc, main_win, preview_win):
        self.doc = doc
        self.main_win = main_win       # fájlnév ablak = kivetítés
        self.preview_win = preview_win # preview ablak = következő dia
        self.current_index = 0
        self.update_windows()

    def next_slide(self):
        if self.current_index < len(self.doc) - 1:
            self.current_index += 1
        self.update_windows()

    def prev_slide(self):
        if self.current_index > 0:
            self.current_index -= 1
        self.update_windows()

    def update_windows(self):
        # Main ablak = current slide
        current_index = self.current_index

        # Preview = next slide, ha van
        if self.current_index < len(self.doc) - 1:
            next_index = self.current_index + 1
        else:
            next_index = None

        # Ablak méretek
        main_alloc = self.main_win.get_allocation()
        preview_alloc = self.preview_win.get_allocation()

        # Render
        self.main_win.show_page(render_page(self.doc, current_index, main_alloc.width, main_alloc.height))
        self.preview_win.show_page(render_page(self.doc, next_index, preview_alloc.width, preview_alloc.height))

# ---------------- Main ----------------
def main():
    try:
        doc = fitz.open(PDF_FILE)
    except Exception as e:
        print(f"Hiba PDF megnyitásakor: {e}")
        sys.exit(1)

    # Fő ablak = main/kivetítés
    main_win = SlideWindow(title=PDF_FILE, borderless=False, monitor_index=1)
    # Preview ablak = következő dia
    preview_win = SlideWindow(title="Preview", borderless=True, monitor_index=0)

    controller = SlideController(doc, main_win, preview_win)
    # Kapcsoljuk az ablakokhoz a controllert a size-allocate esemény miatt
    main_win.controller = controller
    preview_win.controller = controller

    def on_key(window, event):
        key = Gdk.keyval_name(event.keyval)
        if key in ("j", "space"):
            controller.next_slide()
        elif key == "k":
            controller.prev_slide()
        elif key == "Escape":
            Gtk.main_quit()
        return True

    main_win.connect("key-press-event", on_key)
    preview_win.connect("key-press-event", on_key)

    Gtk.main()

if __name__ == "__main__":
    main()
