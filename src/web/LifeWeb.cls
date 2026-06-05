Class demo.LifeWeb Extends %CSP.Page
{

Parameter CONTENTTYPE = "text/html";

ClassMethod OnPage() As %Status
{
    Set action = %request.Get("action")
    If action = "new"  { Quit ..LifeNew() }
    If action = "step" { Quit ..LifeStep() }
    Do ..ServeHTML()
    Quit $$$OK
}

ClassMethod LifeNew() As %Status
{
    Set %response.ContentType = "application/json"
    Set id = $Translate($Horolog, ",", "") _ "_" _ $Job
    Set w = 24, h = 16
    Set grid = ""
    For i = 1:1:w*h {
        Set cell = "0"
        If $Random(100) < 30 { Set cell = $Select($Random(2) = 0:"1", 1:"2") }
        Set grid = grid _ cell
    }
    Set ^Life(id, "w") = w
    Set ^Life(id, "h") = h
    Set ^Life(id, "gen") = 0
    Set ^Life(id, "M") = grid
    Set ^Life(id, "C") = grid
    Write "{""id"":"""_id_""",""w"":"_w_",""h"":"_h_",""gen"":0,"
    Write """m"":"""_grid_""",""c"":"""_grid_""",""parity"":1,"
    Do ..WritePop(grid)
    Write "}"
    Quit $$$OK
}

ClassMethod LifeStep() As %Status
{
    Set %response.ContentType = "application/json"
    Set id = %request.Get("id")
    If '$Data(^Life(id)) {
        Write "{""error"":""no such game""}"
        Quit $$$OK
    }
    Do Step^demo.life.LifeModern(id)
    Do Step^demo.life.LifeClassic(id)
    Set gen = $Get(^Life(id, "gen")) + 1
    Set ^Life(id, "gen") = gen
    Set m = ^Life(id, "M")
    Set c = ^Life(id, "C")
    Set parity = (m = c)
    Write "{""gen"":"_gen_","
    Write """m"":"""_m_""",""c"":"""_c_""",""parity"":"_parity_","
    Do ..WritePop(m)
    Write "}"
    Quit $$$OK
}

ClassMethod WritePop(grid As %String)
{
    Set amber = 0, ember = 0
    For i = 1:1:$Length(grid) {
        Set ch = $Extract(grid, i)
        If ch = 1 { Set amber = amber + 1 }
        ElseIf ch = 2 { Set ember = ember + 1 }
    }
    Write """amber"":"_amber_",""ember"":"_ember
}

ClassMethod ServeHTML() As %Status
{
    Write "<!DOCTYPE html>",!
    Write "<html lang=""en"">",!
    Write "<head>",!
    Write "<meta charset=""UTF-8"">",!
    Write "<meta name=""viewport"" content=""width=device-width, initial-scale=1"">",!
    Write "<title>LIFE // TWO ENGINES</title>",!
    Write "<style>",!
    Write "  * { margin:0; padding:0; box-sizing:border-box; }",!
    Write "  body { background:#140d00; color:#ffb000; font-family:'Courier New',monospace;",!
    Write "         display:flex; flex-direction:column; align-items:center; min-height:100vh;",!
    Write "         padding:1.5rem; gap:1rem; }",!
    Write "  h1 { font-size:1.4rem; letter-spacing:0.4em; text-shadow:0 0 12px #ff8c00; }",!
    Write "  #subtitle { font-size:0.6rem; letter-spacing:0.25em; color:#7a4a00; }",!
    Write "  .bar { display:flex; gap:1.4rem; align-items:center; font-size:0.7rem;",!
    Write "         letter-spacing:0.15em; flex-wrap:wrap; justify-content:center; }",!
    Write "  .arena { display:flex; flex-wrap:wrap; gap:2rem; justify-content:center;",!
    Write "           align-items:flex-start; margin-top:0.5rem; }",!
    Write "  .panel { display:flex; flex-direction:column; align-items:center; gap:0.6rem;",!
    Write "           border:1px solid #4a3000; padding:1rem; border-radius:4px; }",!
    Write "  .panel h2 { font-size:0.85rem; letter-spacing:0.3em; }",!
    Write "  .tag { font-size:0.55rem; letter-spacing:0.15em; min-height:1.2em; }",!
    Write "  .tag.ok  { color:#6aff6a; }",!
    Write "  .tag.bad { color:#ff5a3c; }",!
    Write "  .board { display:grid; gap:1px; background:#3a2600; padding:1px;",!
    Write "           border:1px solid #4a3000; }",!
    Write "  .c { width:13px; height:13px; background:#0a0600; transition:background 0.12s; }",!
    Write "  .c.a { background:#ffb000; box-shadow:0 0 4px #ffb000; }",!
    Write "  .c.b { background:#ff4e00; box-shadow:0 0 4px #ff4e00; }",!
    Write "  .pops { display:flex; gap:0.5rem; align-items:center; font-size:0.6rem; }",!
    Write "  .swatch { width:9px; height:9px; display:inline-block; vertical-align:middle; }",!
    Write "  .swatch.a { background:#ffb000; } .swatch.b { background:#ff4e00; }",!
    Write "  button { background:none; border:1px solid #ffb000; color:#ffb000;",!
    Write "           font-family:'Courier New',monospace; font-size:0.75rem;",!
    Write "           padding:0.5rem 1.4rem; cursor:pointer; letter-spacing:0.2em;",!
    Write "           transition:background 0.15s, color 0.15s; }",!
    Write "  button:hover { background:#ffb000; color:#140d00; }",!
    Write "  #parity { font-size:0.8rem; letter-spacing:0.2em; padding:0.3rem 0.8rem;",!
    Write "            border:1px solid #4a3000; }",!
    Write "  #parity.ok  { color:#6aff6a; border-color:#2a6a2a; }",!
    Write "  #parity.bad { color:#ff5a3c; border-color:#6a2a2a; text-shadow:0 0 8px #ff5a3c; }",!
    Write "  .health { border:1px solid #4a3000; padding:0.8rem 1rem; font-size:0.62rem;",!
    Write "            letter-spacing:0.1em; line-height:1.7; max-width:300px; }",!
    Write "  .health .h2  { color:#6aff6a; } .health .hx { color:#ff5a3c; }",!
    Write "  .health .note { color:#7a4a00; font-size:0.55rem; margin-top:0.4rem; }",!
    Write "</style>",!
    Write "</head>",!
    Write "<body>",!
    Write "  <h1>LIFE // TWO ENGINES</h1>",!
    Write "  <div id=""subtitle"">CONWAY IMMIGRATION GAME // ONE TRUTH, TWO OBJECTSCRIPT ENGINES</div>",!
    Write "  <div class=""bar"">",!
    Write "    <span>GEN <span id=""gen"">0</span></span>",!
    Write "    <span id=""parity"" class=""ok"">PARITY OK</span>",!
    Write "    <span class=""pops""><span class=""swatch a""></span> AMBER <span id=""amber"">0</span></span>",!
    Write "    <span class=""pops""><span class=""swatch b""></span> EMBER <span id=""ember"">0</span></span>",!
    Write "    <button onclick=""toggle()"" id=""playbtn"">[ PAUSE ]</button>",!
    Write "    <button onclick=""newGame()"">[ RESEED ]</button>",!
    Write "  </div>",!
    Write "  <div class=""arena"">",!
    Write "    <div class=""panel"">",!
    Write "      <h2>MODERN ENGINE</h2>",!
    Write "      <div class=""tag ok"">structured block syntax</div>",!
    Write "      <div class=""board"" id=""board-m""></div>",!
    Write "    </div>",!
    Write "    <div class=""panel"">",!
    Write "      <h2>CLASSIC ENGINE</h2>",!
    Write "      <div class=""tag bad"">legacy: goto / xecute / kill</div>",!
    Write "      <div class=""board"" id=""board-c""></div>",!
    Write "    </div>",!
    Write "    <div class=""health"">",!
    Write "      <div>CODE HEALTH (oto-lint)</div>",!
    Write "      <div class=""h2"">&#9656; MODERN&nbsp;&nbsp;0 issues</div>",!
    Write "      <div class=""hx"">&#9656; CLASSIC 18 issues</div>",!
    Write "      <div>&nbsp;&nbsp;1 goto-usage</div>",!
    Write "      <div>&nbsp;&nbsp;1 xecute-usage</div>",!
    Write "      <div>&nbsp;&nbsp;1 kill-all</div>",!
    Write "      <div>&nbsp;10 postconditional</div>",!
    Write "      <div>&nbsp;&nbsp;5 inline if/for</div>",!
    Write "      <div class=""note"">same output, very different code.<br>findings render live in CI on every PR.</div>",!
    Write "    </div>",!
    Write "  </div>",!
    Write "<script>",!
    Write "let GID=null, W=24, H=16, timer=null, playing=true;",!
    Write "function buildBoard(elId){",!
    Write "  const b=document.getElementById(elId);",!
    Write "  b.style.gridTemplateColumns='repeat('+W+',13px)';",!
    Write "  b.innerHTML='';",!
    Write "  for(let i=0;i<W*H;i++){const d=document.createElement('div');d.className='c';b.appendChild(d);}",!
    Write "}",!
    Write "function render(elId,grid){",!
    Write "  const cells=document.getElementById(elId).children;",!
    Write "  for(let i=0;i<grid.length;i++){",!
    Write "    const ch=grid[i]; const cl=ch==='1'?'c a':(ch==='2'?'c b':'c');",!
    Write "    if(cells[i].className!==cl) cells[i].className=cl;",!
    Write "  }",!
    Write "}",!
    Write "function setStats(d){",!
    Write "  document.getElementById('gen').textContent=d.gen;",!
    Write "  document.getElementById('amber').textContent=d.amber;",!
    Write "  document.getElementById('ember').textContent=d.ember;",!
    Write "  const p=document.getElementById('parity');",!
    Write "  if(d.parity){p.className='ok';p.textContent='PARITY OK';}",!
    Write "  else{p.className='bad';p.textContent='DIVERGED!';}",!
    Write "}",!
    Write "async function newGame(){",!
    Write "  const d=await(await fetch('?action=new')).json();",!
    Write "  GID=d.id; render('board-m',d.m); render('board-c',d.c); setStats(d);",!
    Write "  if(!playing) toggle();",!
    Write "}",!
    Write "async function tick(){",!
    Write "  if(!GID) return;",!
    Write "  const d=await(await fetch('?action=step&id='+encodeURIComponent(GID))).json();",!
    Write "  if(d.error) return;",!
    Write "  render('board-m',d.m); render('board-c',d.c); setStats(d);",!
    Write "}",!
    Write "function toggle(){",!
    Write "  playing=!playing;",!
    Write "  document.getElementById('playbtn').textContent=playing?'[ PAUSE ]':'[ PLAY ]';",!
    Write "  if(playing){timer=setInterval(tick,160);} else {clearInterval(timer);timer=null;}",!
    Write "}",!
    Write "buildBoard('board-m'); buildBoard('board-c');",!
    Write "newGame().then(()=>{ if(!timer) timer=setInterval(tick,160); });",!
    Write "</script>",!
    Write "</body>",!
    Write "</html>",!
    Quit $$$OK
}

}
