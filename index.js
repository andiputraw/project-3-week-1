
let gridPtr = 0
/**
 * @type {ArrayBuffer}
 */
let wasmMem = undefined
/**
 * @type {DataView}
 */
let wasmMemView = undefined
/**
 * @type {CanvasRenderingContext2D}
 */
let ctx
/**
 * @type {Uint8Array}
 */
let grid

const GRID_WIDTH = 128
const GRID_HEIGHT = 128
const GRID_LEN = GRID_WIDTH * GRID_HEIGHT

const CANVAS_WIDTH= 360
const CANVAS_HEIGHT = 360

const CELL_WIDTH=CANVAS_WIDTH/GRID_WIDTH

function LogGrid() {
    // const grid = new Uint8Array(wasmMem, gridPtr, 8 * 8);
    console.log(grid)
}

function $2Dto1D(x, y) {
    return y * GRID_HEIGHT + x
}

function $2Dto1D(index) {
    let y = Math.floor(index / GRID_HEIGHT)
    let x = index % GRID_WIDTH
    return {x, y}
}

async function sleep(sec) {
    return new Promise((resolve, reject) => {  
        setTimeout(() => {
            resolve()
        }, sec * 1_000);
    })
}

async function envPrint(...val) {
    console.log(val)
}

async function main() {
       setupCanvas();
    let wasmInstance
    try {
        wasmInstance = (await WebAssembly.instantiateStreaming(fetch("./wasm/main.wasm"), {
            env: {
                print1 : envPrint,
                print2 : envPrint,
                print3 : envPrint,
                random : () => BigInt(Math.floor(Math.random() * 1000000)) , 
            }
        })).instance
    } catch(err) {
        ctx.fillStyle = 'white'
        ctx.fillText("WASM gagal diambil. Coba buka website versi online", 20,20)
        ctx.fillText("atau jalankan pada sebuah server (vscode live server/python server)", 20,40)
        return
    }
    console.log(wasmInstance)
    const stepFn = wasmInstance.exports.step
    const getGridPtr = wasmInstance.exports.getGridPtr;
    const initFn = wasmInstance.exports.init;

    gridPtr = getGridPtr()
    wasmMem = wasmInstance.exports.memory.buffer
    wasmMemView = new DataView(wasmMem)
    grid = new  Uint8Array(wasmMem, gridPtr, GRID_LEN);

 
    initFn()
    
    LogGrid()
    document.addEventListener('keypress', (ev) => {
        if(ev.code = "KeyN") stepFn();
    })
    while(true) {
        stepFn()
        for(let i = 0; i < GRID_LEN; i++) {
            let {x, y} = $2Dto1D(i)
            if (grid[i] == 0) {
                ctx.fillStyle = 'black'
            }else {
                ctx.fillStyle = 'white'
            }
            ctx.fillRect(x * CELL_WIDTH, y * CELL_WIDTH, CELL_WIDTH, CELL_WIDTH);
        }
        await sleep(0.05)
    }
}

function setupCanvas() {
    /**
     * @type {HTMLCanvasElement}
     */
    const canvas = document.getElementById('canvas')
    
    if(!canvas) {
        console.error("Cannot get canvas element")
        return
    }
    canvas.width = CANVAS_WIDTH
    canvas.height = CANVAS_HEIGHT

    ctx = canvas.getContext('2d')
    if(!ctx) {
        console.error("Cannot get canvas context")
        return
    }
}

main()