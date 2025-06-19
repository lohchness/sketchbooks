Cell rootCell;
ArrayList <Cell> cellsList;

int maxLv = 3;
float rX, rXT, rY, rYT;
float scalar = 1, scalarT = 1;

void setup() {
    size(600, 600, P3D);
    hint(DISABLE_DEPTH_TEST);
    frameRate(30);

    cellsList = new ArrayList<Cell>();
    rootCell = new Cell(0, 300);
    cellsList.add(rootCell);
}

void draw() {
    rXT = (mouseY-height*.5)*.01;
    rYT = (mouseX-width*.5)*.01;
    rX = lerp(rX, rXT, .25);
    rY = lerp(rY, rYT, .25);    
    scalar = lerp(scalar, scalarT, .25);
    rootCell.update();
    
    translate(width*.5, height*.5);
    rotateX(rX);
    rotateY(rY);
    scale(scalar);
    background(0);
    rootCell.display();
}

class Cell {

    int interval = 2, lv;
    float cellSize;

    boolean hasChildren, hasSeg;
    ArrayList <Cell> cCells;
    ArrayList <CurveSeg> segs, cSegs;

    Vtx [][][] bds;

    Cell(int lv, float cellSize) {
        this.lv = lv;
        this.cellSize = cellSize;
        initRootBds();
        initRootSeg();
    }

    Cell(int lv, Vtx bd0, Vtx bd1, Vtx bd2, Vtx bd3, Vtx bd4, Vtx bd5, Vtx bd6, Vtx bd7) {
        this.lv = lv;
        initBds(bd0, bd1, bd2, bd3, bd4, bd5, bd6, bd7);
        segs = new ArrayList<CurveSeg>();
    }

    void reset() {
        if (hasChildren) {
            for (int i=cSegs.size ()-1; i>-1; i--) {
                cSegs.remove(i);
            }
            for (int i=cCells.size ()-1; i>-1; i--) {
                cCells.remove(i);
            }
            hasChildren = false;
        }
        if (hasSeg) {
            for (int i=segs.size ()-1; i>-1; i--) {
                segs.remove(i);
            }
            hasSeg = false;
        }
        for (int i=0; i<2; i++) {
            for (int j=0; j<2; j++) {
                for (int k=0; k<2; k++) {
                    int lyrIdx = i*interval;
                    int rowIdx = j*interval;
                    int colIdx = k*interval;
                    bds[lyrIdx][rowIdx][colIdx].occupied = false;
                }
            }
        }
    }

    void initRootSeg() {
        hasSeg = true;
        segs = new ArrayList<CurveSeg>();
        for (int i=0; i<2; i++) {
            for (int j=0; j<1; ) {
                int sLyr = round(random(1))*2;
                int sRow = round(random(1))*2;
                int sCol = round(random(1))*2;
                int eLyr = round(random(1))*2;
                int eRow = round(random(1))*2;
                int eCol = round(random(1))*2;
                if ((sLyr == eLyr && sRow == eRow && sCol == eCol) ||
                    (sLyr != eLyr && sRow != eRow && sCol != eCol) ||
                    (bds[sLyr][sRow][sCol].occupied || bds[eLyr][eRow][eCol].occupied)) {
                    continue;
                } else {
                    bds[sLyr][sRow][sCol].occupied = true;
                    bds[eLyr][eRow][eCol].occupied = true;

                    CurveSeg initSeg = new CurveSeg(bds[sLyr][sRow][sCol], bds[eLyr][eRow][eCol]);
                    initSeg.setV1Indices(sLyr, sRow, sCol);
                    initSeg.setV2Indices(eLyr, eRow, eCol);
                    int [] ctlIndices = initSeg.ctlIndices();
                    initSeg.setCtls(bds[ctlIndices[0]][ctlIndices[1]][ctlIndices[2]], bds[ctlIndices[3]][ctlIndices[4]][ctlIndices[5]]);
                    segs.add(initSeg);

                    break;
                }
            }
        }
    }

    void addSeg(CurveSeg seg) {
        hasSeg = true;
        for (int l=0; l<2; l++) {
            for (int m=0; m<2; m++) {
                for (int n=0; n<2; n++) {
                    if (seg.acr1 == bds[l*interval][m*interval][n*interval])seg.setV1Indices(l*interval, m*interval, n*interval);
                    else if (seg.acr2 == bds[l*interval][m*interval][n*interval])seg.setV2Indices(l*interval, m*interval, n*interval);
                }
            }
        }
        int [] ctlIndices = seg.ctlIndices();
        seg.setCtls(bds[ctlIndices[0]][ctlIndices[1]][ctlIndices[2]], bds[ctlIndices[3]][ctlIndices[4]][ctlIndices[5]]);
        segs.add(seg);
    }

    void initRootBds() {
        bds = new Vtx[3][3][3];
        for (int i=0; i<2; i++) {
            for (int j=0; j<2; j++) {
                for (int k=0; k<2; k++) {
                    int lyrIdx = i*interval;
                    int rowIdx = j*interval;
                    int colIdx = k*interval;
                    bds[lyrIdx][rowIdx][colIdx] = new Vtx(new PVector(0, 0, 0), new PVector(cellSize*(-.5+k), cellSize*(-.5+j), cellSize*(.5-i)), 0);
                }
            }
        }
    }

    void initBds(Vtx bd0, Vtx bd1, Vtx bd2, Vtx bd3, Vtx bd4, Vtx bd5, Vtx bd6, Vtx bd7) {
        bds = new Vtx[3][3][3];
        bds[0][0][0] = bd0;
        bds[0][0][interval] = bd1;
        bds[0][interval][interval] = bd2;
        bds[0][interval][0] = bd3;
        bds[interval][0][0] = bd4;
        bds[interval][0][interval] = bd5;
        bds[interval][interval][interval] = bd6;
        bds[interval][interval][0] = bd7;
    }

    PVector itpPos(Vtx v1, Vtx v2, float ratio) {
        PVector result = new PVector(
        v1.acr.x*ratio + v2.acr.x*(1-ratio), 
        v1.acr.y*ratio + v2.acr.y*(1-ratio), 
        v1.acr.z*ratio + v2.acr.z*(1-ratio)
            );
        return result;
    }

    void initCtrs() {
        for (int i=0; i<3; i++) {
            for (int j=0; j<3; j++) {
                for (int k=0; k<3; k++) {
                    if (k==1 && i!=1 && j!=1) {
                        bds[i][j][k] = new Vtx(itpPos(bds[i][j][k-1], bds[i][j][k+1], random(1)), itpPos(bds[i][j][k-1], bds[i][j][k+1], .5), lv);
                    } else if (i==1 && k!=1 && j!=1) {
                        bds[i][j][k] = new Vtx(itpPos(bds[i-1][j][k], bds[i+1][j][k], random(1)), itpPos(bds[i-1][j][k], bds[i+1][j][k], .5), lv);
                    } else if (j==1 && k!=1 && i!=1) {
                        bds[i][j][k] = new Vtx(itpPos(bds[i][j-1][k], bds[i][j+1][k], random(1)), itpPos(bds[i][j-1][k], bds[i][j+1][k], .5), lv);
                    } else if (i==1 && j==1 && k!=1) {
                        bds[i][j][k] = new Vtx(itpPos(bds[i-1][j-1][k], bds[i+1][j+1][k], random(1)), itpPos(bds[i-1][j-1][k], bds[i+1][j+1][k], .5), lv);
                    } else if (i==1 && k==1 && j!=1) {
                        bds[i][j][k] = new Vtx(itpPos(bds[i-1][j][k-1], bds[i+1][j][k+1], random(1)), itpPos(bds[i-1][j][k-1], bds[i+1][j][k+1], .5), lv);
                    } else if (j==1 && k==1 && i!=1) {
                        bds[i][j][k] = new Vtx(itpPos(bds[i][j-1][k-1], bds[i][j+1][k+1], random(1)), itpPos(bds[i][j-1][k-1], bds[i][j+1][k+1], .5), lv);
                    } else if (i==1 && j==1 && k==1) {
                        bds[i][j][k] = new Vtx(itpPos(bds[i-1][j-1][k-1], bds[i+1][j+1][k+1], random(1)), itpPos(bds[i-1][j-1][k-1], bds[i+1][j+1][k+1], .5), lv);
                    }
                }
            }
        }
    }

    void spawnChildren() {
        initCtrs();
        if (hasSeg) divideSeg();
        hasChildren = true;
        cCells = new ArrayList<Cell>();
        for (int i=0; i<2; i++) {
            for (int j=0; j<2; j++) {
                for (int k=0; k<2; k++) {
                    Cell cCell = new Cell(lv+1, bds[i][j][k], bds[i][j][k+1], bds[i][j+1][k+1], bds[i][j+1][k], bds[i+1][j][k], bds[i+1][j][k+1], bds[i+1][j+1][k+1], bds[i+1][j+1][k]);
                    cCells.add(cCell);
                    cellsList.add(cCell);
                }
            }
        }

        if (hasSeg) {
            for (int i=0; i<cSegs.size (); i++) {
                CurveSeg cSeg = cSegs.get(i);
                Vtx v1 = cSeg.acr1;
                Vtx v2 = cSeg.acr2;
                int iterations = 0;
                for (int j=0; j<1; ) {
                    int matched = 0;
                    int randIndex = floor(random(cCells.size()));
                    Cell randCCell = cCells.get(randIndex);
                    for (int l=0; l<2; l++) {
                        for (int m=0; m<2; m++) {
                            for (int n=0; n<2; n++) {
                                if (v1 == randCCell.bds[l*interval][m*interval][n*interval]) matched++;
                                else if (v2 == randCCell.bds[l*interval][m*interval][n*interval]) matched++;
                            }
                        }
                    }
                    iterations++;
                    if (matched == 2) {
                        randCCell.addSeg(cSeg);
                        break;
                    } else if (iterations == 100) {
                        break;
                    }
                }
            }
        }
    }

    void divideSeg() {
        cSegs = new ArrayList<CurveSeg>();
        for (int i=segs.size ()-1; i>-1; i--) {
            CurveSeg seg = segs.get(i);
            int [] sNbBound = nbRandBd(seg.sLyr, seg.sRow, seg.sCol);
            int [] eNbBound = nbRandBd(seg.eLyr, seg.eRow, seg.eCol);

            if (sNbBound[0] == eNbBound[0] && sNbBound[1] == eNbBound[1] && sNbBound[2] == eNbBound[2]) {

                bds[sNbBound[0]][sNbBound[1]][sNbBound[2]].occupied = true;

                CurveSeg cSeg1 = new CurveSeg(seg.acr1, bds[sNbBound[0]][sNbBound[1]][sNbBound[2]]);
                CurveSeg cSeg2 = new CurveSeg(bds[sNbBound[0]][sNbBound[1]][sNbBound[2]], seg.acr2);
                cSegs.add(cSeg1);
                cSegs.add(cSeg2);
            } else {
                bds[sNbBound[0]][sNbBound[1]][sNbBound[2]].occupied = true;
                bds[1][1][1].occupied = true;
                bds[eNbBound[0]][eNbBound[1]][eNbBound[2]].occupied = true;

                CurveSeg cSeg1 = new CurveSeg(seg.acr1, bds[sNbBound[0]][sNbBound[1]][sNbBound[2]]);
                CurveSeg cSeg2 = new CurveSeg(bds[sNbBound[0]][sNbBound[1]][sNbBound[2]], bds[1][1][1]);
                CurveSeg cSeg3 = new CurveSeg(bds[1][1][1], bds[eNbBound[0]][eNbBound[1]][eNbBound[2]]);
                CurveSeg cSeg4 = new CurveSeg(bds[eNbBound[0]][eNbBound[1]][eNbBound[2]], seg.acr2);
                cSegs.add(cSeg1);
                cSegs.add(cSeg2);
                cSegs.add(cSeg3);
                cSegs.add(cSeg4);
            }
            segs.remove(seg);
        }
    }

    int [] nbRandBd(int lyrIdx, int rowIdx, int colIdx) {
        int nxtLyrIdx = 0, nxtRowIdx = 0, nxtColIdx = 0;
        for (int i=0; i<1; ) {

            if (lyrIdx == 0) nxtLyrIdx = lyrIdx + round(random(1));
            else if (lyrIdx == interval) nxtLyrIdx = lyrIdx - round(random(1));
            if (rowIdx == 0) nxtRowIdx = rowIdx + round(random(1));
            else if (rowIdx == interval) nxtRowIdx = rowIdx - round(random(1));
            if (colIdx == 0) nxtColIdx = colIdx + round(random(1));
            else if (colIdx == interval) nxtColIdx = colIdx - round(random(1));

            if ((lyrIdx == nxtLyrIdx && rowIdx == nxtRowIdx && colIdx == nxtColIdx) ||
                (lyrIdx != nxtLyrIdx && rowIdx != nxtRowIdx && colIdx != nxtColIdx)||
                (bds[nxtLyrIdx][nxtRowIdx][nxtColIdx].occupied)) {
                continue;
            } else {
                break;
            }
        }
        return new int[] {
            nxtLyrIdx, nxtRowIdx, nxtColIdx
        };
    }

    void update() {
        for (int i=0; i<2; i++) {
            for (int j=0; j<2; j++) {
                for (int k=0; k<2; k++) {
                    int lyrIdx = i*interval;
                    int rowIdx = j*interval;
                    int colIdx = k*interval;
                    bds[lyrIdx][rowIdx][colIdx].update();
                }
            }
        }

        if (hasChildren) {
            for (int i=0; i<cCells.size (); i++) {
                Cell cCell = cCells.get(i);
                cCell.update();
            }
        }
    }

    void display() {
        if (hasSeg) drawSegs();
        if (hasChildren) {
            for (int i=0; i<cCells.size (); i++) {
                Cell cCell = cCells.get(i);
                cCell.display();
            }
        } else {
            drawEdges();
        }
    }

    void drawEdges() {
        for (int i=0; i<2; i++) {
            for (int j=0; j<2; j++) {
                for (int k=0; k<2; k++) {
                    int lyrIdx = i*interval;
                    int rowIdx = j*interval;
                    int colIdx = k*interval;
                    if (k<1) drawEdge(bds[lyrIdx][rowIdx][colIdx], bds[lyrIdx][rowIdx][colIdx+interval]);
                    if (j<1) drawEdge(bds[lyrIdx][rowIdx][colIdx], bds[lyrIdx][rowIdx+interval][colIdx]);
                    if (i<1) drawEdge(bds[lyrIdx][rowIdx][colIdx], bds[lyrIdx+interval][rowIdx][colIdx]);
                }
            }
        }
    }

    void drawSegs() {
        for (int i=0; i<segs.size (); i++) {
            CurveSeg seg = segs.get(i);
            seg.display();
        }
    }


    void drawEdge(Vtx v1, Vtx v2) {
        stroke(255, 32);
        strokeWeight(1);
        line(v1.pos.x, v1.pos.y, v1.pos.z, v2.pos.x, v2.pos.y, v2.pos.z);
    }
}


void spawnCell() {
    int iterations = 0;
    for (int i=0; i<1; ) {
        iterations++;
        Cell randCell = cellsList.get(floor(random(cellsList.size())));
        if (!randCell.hasChildren && randCell.hasSeg && randCell.lv<maxLv) {
            randCell.spawnChildren();
            break;
        } else if (iterations == 100) {
            break;
        }
    }
}

class CurveSeg{
    
    Vtx acr1, acr2, ctl1, ctl2;
    
    int sLyr, sRow, sCol, eLyr, eRow, eCol;
    int mode;
    float ratio;
    
    CurveSeg(Vtx acr1, Vtx acr2){
        this.acr1 = acr1;
        this.acr2 = acr2;
    }
    
    void setCtls(Vtx ctl1, Vtx ctl2){
        this.ctl1 = ctl1;
        this.ctl2 = ctl2;
    }
    
    void setV1Indices(int sLyr, int sRow, int sCol){
        this.sLyr = sLyr;
        this.sRow = sRow;
        this.sCol = sCol;
    }
    
    void setV2Indices(int eLyr, int eRow, int eCol){
        this.eLyr = eLyr;
        this.eRow = eRow;
        this.eCol = eCol;
    }
    
    int [] ctlIndices(){
        int [] result = new int[]{};
        if(sLyr == eLyr && sRow == eRow){
            if(boolean(round(random(1)))){
                result = new int[]{(sLyr+2)%4, sRow, sCol, (eLyr+2)%4, eRow, eCol};
            }else{
                result = new int[]{sLyr, (sRow+2)%4, sCol, eLyr, (eRow+2)%4, eCol};
            }
            ratio = 0.65;
        }else if(sLyr == eLyr && sCol == eCol){
            if(boolean(round(random(1)))){
                result = new int[]{(sLyr+2)%4, sRow, sCol, (eLyr+2)%4, eRow, eCol};
            }else{
                result = new int[]{sLyr, sRow, (sCol+2)%4, eLyr, eRow, (eCol+2)%4};
            }
            ratio = 0.65;
        }else if(sRow == eRow && sCol == eCol){
            if(boolean(round(random(1)))){
                result = new int[]{sLyr, (sRow+2)%4, sCol, eLyr, (eRow+2)%4, eCol};
            }else{
                result = new int[]{sLyr, sRow, (sCol+2)%4, eLyr, eRow, (eCol+2)%4};
            }
            ratio = 0.65;
        }else if(sLyr == eLyr){
            if(boolean(round(random(1)))){
                result = new int[]{sLyr, (sRow+2)%4, sCol, sLyr, (sRow+2)%4, sCol};
            }else{
                result = new int[]{sLyr, sRow, (sCol+2)%4, sLyr, sRow, (sCol+2)%4};
            }
            ratio = 0.55;
        }else if(sRow == eRow){
            if(boolean(round(random(1)))){
                result = new int[]{(sLyr+2)%4, sRow, sCol, (sLyr+2)%4, sRow, sCol};
            }else{
                result = new int[]{sLyr, sRow, (sCol+2)%4, sLyr, sRow, (sCol+2)%4};
            }
            ratio = 0.55;
        }else if(sCol == eCol){
            if(boolean(round(random(1)))){
                result = new int[]{(sLyr+2)%4, sRow, sCol, (sLyr+2)%4, sRow, sCol};
            }else{
                result = new int[]{sLyr, (sRow+2)%4, sCol, sLyr, (sRow+2)%4, sCol};
            }
            ratio = 0.55;
        }
        return result;
    }
    
    void display(){
        noFill();
        stroke(255);
        strokeWeight(2);
        bezier(acr1.pos.x, acr1.pos.y, acr1.pos.z, 
        ctl1.pos.x*ratio+acr1.pos.x*(1-ratio),ctl1.pos.y*ratio+acr1.pos.y*(1-ratio), ctl1.pos.z*ratio+acr1.pos.z*(1-ratio), 
        ctl2.pos.x*ratio+acr2.pos.x*(1-ratio), ctl2.pos.y*ratio+acr2.pos.y*(1-ratio), ctl2.pos.z*ratio+acr2.pos.z*(1-ratio), 
        acr2.pos.x, acr2.pos.y, acr2.pos.z);
    }
}
class Vtx {
    boolean occupied;
    PVector acr, pos, tgt;
    PVector vel, acc;
    float decay;
    int lv;
    
    Vtx(PVector initPos, PVector acr, int lv){
        this.acr = new PVector(acr.x, acr.y, acr.z);
        tgt = new PVector(acr.x, acr.y, acr.z);
        pos = new PVector(initPos.x, initPos.y, initPos.z);
        
        this.lv = lv;
        
        vel = new PVector(0, 0, 0);
        acc = new PVector(0, 0, 0);
        
        decay = random(0.8, 0.9);
    }

    void update() {
        acc = PVector.sub(tgt, pos);
        acc.mult(.025);
        vel.add(acc);
        pos.add(vel);
        vel.mult(decay);
        acc.set(0, 0, 0);
    }
}

void keyPressed() {
    if (key == '1') {
        spawnCell();
    } else if ( key == '2') {
        for (int i=cellsList.size ()-1; i>-1; i--) {
            Cell eachCell = cellsList.get(i);
            eachCell.reset();
            if (eachCell != rootCell)cellsList.remove(i);
        }
        rootCell.initRootSeg();
    }else if(key == 'w'){
        scalarT += .05;
        scalarT = constrain(scalarT, .25, 5);
    }else if(key == 's'){
        scalarT -= .05;
        scalarT = constrain(scalarT, .25, 5);
    }
}
