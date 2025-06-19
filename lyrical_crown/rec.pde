final String sketchName = getClass().getName();

import com.hamoid.*;
VideoExport videoExport;

void rec() {
    if (frameCount == 1) {
        videoExport = new VideoExport(this, "../" + sketchName + ".mp4");
        videoExport.setFrameRate(fps);
        videoExport.startMovie();
    }
    videoExport.saveFrame();
}
