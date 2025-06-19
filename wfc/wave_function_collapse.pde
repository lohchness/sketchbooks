int gridSize = 25;
int windowSize = 500;

public RuleList globalLookup; 

Grid grid;

void settings()
{
  size(windowSize, windowSize);
}

void draw()
{

  grid.pickNext();
  grid.updateCells();

  grid.draw();
}

class Cell
{
  private PVector position;
  private int size;

  private Options options;

  private boolean collapsed = false;
  private Option option;
  
  private boolean uncollapsed = false;


  public Cell(PVector position, int size)
  {
    this.position = position;
    this.size = size;

    options = new Options();
  }

  public boolean collapse()
  {
    option = options.getRandomOption();

    if (option == null) return false;

    collapsed = true;
    option.image.resize(size, size);
    
    uncollapsed = false;
    
    return true;
  }
  
  public void uncollapse()
  {
    uncollapsed = true;
    
     collapsed = false;
     option = null;
     
     options = new Options();
  }

  public void draw()
  {
    if (!collapsed) {
      strokeWeight(1);
      stroke(100);
      fill(30);
      
      if(uncollapsed) fill(200, 50, 50);
      
      rect(position.x, position.y, size, size);
      
      
      
      //fill(255);
      //text(options.size(), position.x + size/2, position.y + size/2);
    } else {
      imageMode(CENTER);
      pushMatrix();
      translate(position.x + size/2, position.y + size/2);
      rotate(radians(-90) * option.rotations);
      image(option.image, 0, 0);
      popMatrix();
      fill(255);
      //text(option.rules.up[0], position.x + size/2, position.y + size/2 - 10);
      //text(option.rules.right[0], position.x + size/2 + 10, position.y + size/2);
      //text(option.rules.down[0], position.x + size/2, position.y + size/2 + 10);
      //text(option.rules.left[0], position.x + size/2 - 10, position.y + size/2);
      //text(option.name, position.x + size/2, position.y + size/2);
    }
  }
}

class Grid
{
  private int gridSize;
  private int windowSize;

  private Cell[][] cells;

  private ArrayList<Integer> uncollapsed;

  public Grid(int gridSize, int windowSize)
  {
    this.gridSize = gridSize;
    this.windowSize = windowSize;

    cells = new Cell[gridSize][gridSize];

    initGrid();
    initUncollapsed();

    //cells[gridSize/2][gridSize/2].collapse();
  }

  private void initUncollapsed()
  {
    uncollapsed = new ArrayList<Integer>();

    for (int  i = 0; i < gridSize*gridSize; i++)
    {
      uncollapsed.add(i);
    }
  }

  private void initGrid()
  {
    int cellSize = windowSize/gridSize;

    for (int  i = 0; i < gridSize; i++)
    {
      for (int  j = 0; j < gridSize; j++)
      {
        cells[i][j] = new Cell(new PVector(i * cellSize, j * cellSize), cellSize);
      }
    }
  }

  public void updateCells()
  {
    for (int  i = 0; i < gridSize; i++)
    {
      for (int  j = 0; j < gridSize; j++)
      {
        if (cells[i][j].collapsed)
        {
          if (i - 1 >= 0) 
          {
            cells[i - 1][j].options.setOptionsByRules(cells[i][j].option.rules, "LEFT");
          }
          if (i + 1 < gridSize) 
          {
            cells[i + 1][j].options.setOptionsByRules(cells[i][j].option.rules, "RIGHT");
          }
          if (j - 1 >= 0) 
          {
            cells[i][j - 1].options.setOptionsByRules(cells[i][j].option.rules, "UP");
          }
          if (j + 1 < gridSize) 
          {
            cells[i][j + 1].options.setOptionsByRules(cells[i][j].option.rules, "DOWN");
          }
        }
      }
    }
  }

  public boolean pickNext()
  {
    int minOp = 999999;
    ArrayList<Cell> cellsToCollapse = new ArrayList<Cell>();
    ArrayList<Integer> cellsToCollapseIndex = new ArrayList<Integer>();

    //println(uncollapsed.size());
    for (Integer i : uncollapsed)
    {
      int op = cells[i / gridSize][i % gridSize].options.size();
      if (op < minOp) minOp = op;
    }

    //for (int  i = 0; i < gridSize; i++)
    //{
    //  for (int  j = 0; j < gridSize; j++)
    //  {
    //    if (!cells[i][j].collapsed)
    //    {
    //      if (cells[i][j].options.size() < minOp &&
    //        cells[i][j].options.size() > 0)
    //      {
    //        minOp = cells[i][j].options.size();
    //      } else if (cells[i][j].options.size() == 0)
    //      {
    //        //initGrid();
    //        //println("zero case");
    //      }
    //    }
    //  }
    //}

    for (Integer i : uncollapsed)
    {
      int op = cells[i / gridSize][i % gridSize].options.size();
      if (cells[i / gridSize][i % gridSize].options.size() == minOp)
      {
        cellsToCollapse.add(cells[i / gridSize][i % gridSize]);
        cellsToCollapseIndex.add(i);
      }
    }

    //for (int  i = 0; i < gridSize; i++)
    //{
    //  for (int  j = 0; j < gridSize; j++)
    //  {
    //    if (!cells[i][j].collapsed)
    //    {
    //      if (cells[i][j].options.size() == minOp)
    //      {
    //        cellsToCollapse.add(cells[i][j]);
    //        cellsToCollapseIndex.add(i * gridSize + j);
    //      }
    //    }
    //  }
    //}

    if (cellsToCollapse.size() < 1)
    {
      //cells[(int)random(gridSize)][(int)random(gridSize)].collapse();
      return false;
    }

    int rand = (int)random(cellsToCollapse.size());

    if (!cellsToCollapse.get(rand).collapse())
    {
      solveUncollapsed(rand);
    }

    uncollapsed.remove(cellsToCollapseIndex.get(rand));

    if (uncollapsed.size() == 0) return false;
    return true;
  }

  public void solveUncollapsed(int index)
  {

    int uncollapsedi = index/gridSize;
    int uncollapsedj = index%gridSize;
    
    println("i:" + index);
    println("x: " + uncollapsedi);
    println("y: " + uncollapsedj);

    int removeSize = 2;

    for (int i = -removeSize; i <= removeSize; i++)
    {
      for (int j = -removeSize; j <= removeSize; j++)
      {
        if((0 <= uncollapsedi + i && uncollapsedi + i < gridSize) && (0 <= uncollapsedj + j && uncollapsedj + j < gridSize))
        {
          int uncollapseIndex = (uncollapsedi + i) * gridSize + (uncollapsedj + j);
          if(uncollapsed.contains(uncollapseIndex))
          {
             cells[uncollapsedi + i][uncollapsedj + j].uncollapse(); 
          }
          else
          {
            uncollapsed.add(uncollapseIndex);
            cells[uncollapsedi + i][uncollapsedj + j].uncollapse();
          }
        }
      }
    }
  }

  public void draw()
  {
    for (int  i = 0; i < gridSize; i++)
    {
      for (int  j = 0; j < gridSize; j++)
      {
        cells[i][j].draw();
      }
    }
  }
}

class Option
{
 
  private String name;
  
  private Rules rules;
  
  private PImage image;
  private int rotations;
  
  public Option(String name, String imagePath, int rotations, Rules rules)
  {
    this.name = name;
    this.rules= new Rules(rules);
    //load image
    this.image = loadImage(imagePath);
    //rotate
    this.rotations = rotations;
    this.rules.rotate(rotations);
    
  }
  
}

class Options
{
  private RuleList lookup;
  private ArrayList<Option> options;

  public Options()
  {
    lookup = globalLookup;

    options = new ArrayList<Option>();
    loadAllOptions();
  }

  public void loadAllOptions()
  {

    for (int i = 0; i < lookup.options.length; i++)
    {
      options.add(lookup.options[i]);
    }
  }

  public Option getRandomOption()
  {
    if (options.size() == 0) 
    {
      println("NO OPTIONS");
      return null;
    }
    if (options.size() == 1) return options.get(0);

    return options.get((int)random(options.size()));
  }

  public void setOptionsByRules(Rules rules, String rulesTo)
  {
    switch(rulesTo)
    {
    case "UP": 
      {
        ArrayList<Option> toRemove = new ArrayList<Option>();
        for(Option o : options)
        {
          if(!o.rules.equalRulesArrays(o.rules.down, rules.up))
          {
            toRemove.add(o);
          }
        }
        for(Option o : toRemove)
        {
           options.remove(o); 
        }
        break;
      }
    case "RIGHT": 
      {
        ArrayList<Option> toRemove = new ArrayList<Option>();
        for(Option o : options)
        {
          if(!o.rules.equalRulesArrays(o.rules.left, rules.right))
          {
            toRemove.add(o);
          }
        }
        for(Option o : toRemove)
        {
           options.remove(o); 
        }
        break;
      }
    case "DOWN": 
      {
        ArrayList<Option> toRemove = new ArrayList<Option>();
        for(Option o : options)
        {
          if(!o.rules.equalRulesArrays(o.rules.up, rules.down))
          {
            toRemove.add(o);
          }
        }
        for(Option o : toRemove)
        {
           options.remove(o); 
        }
        break;
      }
    case "LEFT": 
      {
        ArrayList<Option> toRemove = new ArrayList<Option>();
        for(Option o : options)
        {
          if(!o.rules.equalRulesArrays(o.rules.right, rules.left))
          {
            toRemove.add(o);
          }
        }
        for(Option o : toRemove)
        {
           options.remove(o); 
        }
        break;
      }
    default: 
      break;
    }
  }

  public int size()
  {
    return options.size();
  }
}

class RuleList
{
  public RuleList()
  {
    println("RuleList");
  }

  private Rules X = new Rules(
    new String[]{"x"}, 
    new String[]{"x"}, 
    new String[]{"x"}, 
    new String[]{"x"}
    ); 

  private Rules T = new Rules(
    new String[]{"x"}, 
    new String[]{"i"}, 
    new String[]{"i"}, 
    new String[]{"i"}
    );

  private Rules I = new Rules(
    new String[]{"i"}, 
    new String[]{"x"}, 
    new String[]{"i"}, 
    new String[]{"x"}
    );

  private Rules L = new Rules(
    new String[]{"i"}, 
    new String[]{"i"}, 
    new String[]{"x"}, 
    new String[]{"x"}
    );

  private Rules V = new Rules(
    new String[]{"i"}, 
    new String[]{"x"}, 
    new String[]{"x"}, 
    new String[]{"x"}
    );

  private Rules TR = new Rules(
    new String[]{"w"}, 
    new String[]{"x"}, 
    new String[]{"i"}, 
    new String[]{"x"}
    );

  private Rules W = new Rules(
    new String[]{"x"}, 
    new String[]{"w"}, 
    new String[]{"x"}, 
    new String[]{"w"}
    );

  private Rules BR = new Rules(
    new String[]{"i"}, 
    new String[]{"w"}, 
    new String[]{"i"}, 
    new String[]{"w"}
    );

  public Option[] options = {
    new Option("X", "data/substrate.png", 0, X), 

    new Option("T-r0", "data/t.png", 0, T), 
    new Option("T-r1", "data/t.png", 1, T), 
    new Option("T-r2", "data/t.png", 2, T), 
    new Option("T-r3", "data/t.png", 3, T), 

    new Option("I-r0", "data/track.png", 0, I), 
    new Option("I-r1", "data/track.png", 1, I), 

    new Option("L-r0", "data/turn.png", 0, L), 
    new Option("L-r1", "data/turn.png", 1, L), 
    new Option("L-r2", "data/turn.png", 2, L), 
    new Option("L-r3", "data/turn.png", 3, L), 

    new Option("TR-r0", "data/transition.png", 0, TR), 
    new Option("TR-r1", "data/transition.png", 1, TR), 
    new Option("TR-r2", "data/transition.png", 2, TR), 
    new Option("TR-r3", "data/transition.png", 3, TR), 

    new Option("W-r0", "data/wire.png", 0, W), 
    new Option("W-r1", "data/wire.png", 1, W), 
    new Option("W-r2", "data/wire.png", 2, W), 
    new Option("W-r3", "data/wire.png", 3, W), 

    new Option("BR-r0", "data/bridge.png", 0, BR), 
    new Option("BR-r1", "data/bridge.png", 1, BR), 
    new Option("BR-r2", "data/bridge.png", 2, BR), 
    new Option("BR-r3", "data/bridge.png", 3, BR), 

    new Option("V-r0", "data/vias.png", 0, V), 
    new Option("V-r1", "data/vias.png", 1, V), 
    new Option("V-r2", "data/vias.png", 2, V), 
    new Option("V-r3", "data/vias.png", 3, V)
  };
}

class Rules
{
  public String[] up;
  public String[] down;
  public String[] left;
  public String[] right;

  public Rules(String[] up, String[] right, String[] down, String[] left)
  {
    this.up = new String[up.length];
    this.down = new String[down.length];
    this.left = new String[left.length];
    this.right = new String[right.length];

    arrayCopy(up, this.up);
    arrayCopy(down, this.down);
    arrayCopy(left, this.left);
    arrayCopy(right, this.right);
  }

  public Rules(Rules copyRules)
  {
    this.up = new String[copyRules.up.length];
    this.down = new String[copyRules.down.length];
    this.left = new String[copyRules.left.length];
    this.right = new String[copyRules.right.length];

    arrayCopy(copyRules.up, this.up);
    arrayCopy(copyRules.down, this.down);
    arrayCopy(copyRules.left, this.left);
    arrayCopy(copyRules.right, this.right);
  }

  public boolean equalRulesArrays(String[] r1, String[] r2)
  {
    if (r1.length != r2.length) return false;

    for (int i = 0; i < r1.length; i++)
    {
      if (!r1[i].equals(r2[i])) return false;
    }

    return true;
  }

  public void rotate(int rotations)
  {
    if (rotations > 3) rotations %= 4;

    switch(rotations) {
    case 0: 
      {
        break;
      }
    case 1: 
      {
        String[] temp;
        temp = up;
        up = right;
        right = down;
        down = left;
        left = temp;
        break;
      }
    case 2: 
      {
        String[] temp;
        temp = up;
        up = down;
        down = temp;

        temp = right;
        right = left;
        left = temp;
        break;
      }
    case 3: 
      {
        String[] temp;
        temp = up;
        up = left;
        left = down;
        down = right;
        right = temp;
        break;
      }
    default: 
      break;
    }
  }
}

void setup()
{
  globalLookup = new RuleList();
  grid = new Grid(gridSize, windowSize);

  while (grid.pickNext())
  {
    grid.updateCells();
  }
}
