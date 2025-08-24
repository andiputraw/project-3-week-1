const std = @import("std");

pub export fn add(a: i32, b: i32) i32 {
    return a + b;
}

extern fn print1(a: i32) void;
extern fn print2(a: i32, b: i32) void;
extern fn print3(a: i32, b: i32, c: i32) void;
extern fn random() u64;

const GRID_HEIGHT = 128;
const GRID_WIDTH = 128;
var grid = [_]u8{0} ** (GRID_WIDTH * GRID_HEIGHT);
var next_grid = [_]u8{0} ** (GRID_WIDTH * GRID_HEIGHT);

fn copyGrid() void {
    for (0..grid.len) |i| {
        grid[i] = next_grid[i];
    }
}

fn zeroesNextGrid() void {
    for (0..grid.len) |i| {
        next_grid[i] = 0;
    }
}

fn Vector2D(T: type) type {
    return struct {
        x: T,
        y: T,

        const Self = @This();
        pub fn new(x: T, y: T) Self {
            return .{ .x = x, .y = y };
        }

        pub fn translate(self: Self, x: T, y: T) Self {
            return .{ .x = self.x + x, .y = self.y + y };
        }
        pub fn to1DIndex(self: Self) usize {
            return @as(usize, @intCast((self.y * GRID_HEIGHT) + @as(i32, @intCast(self.x))));
        }
    };
}

pub fn _1DTo2D(index: usize) Vector2D(i32) {
    const y: i32 = @divFloor(@as(i32, @intCast(index)), GRID_HEIGHT);
    const x: i32 = @rem(@as(i32, @intCast(index)), GRID_WIDTH);

    return Vector2D(i32).new(x, y);
}

pub fn _2Dto1D(pos: Vector2D(i32)) usize {
    return @as(usize, @intCast((pos.y * GRID_HEIGHT) + @as(i32, @intCast(pos.x))));
}

pub fn countNeighbour(index: usize) i32 {
    const pos = _1DTo2D(index);
    var count: i32 = 0;

    // print2(pos.x, pos.y);
    for (0..3) |i| {
        for (0..3) |j| {
            const movedX: i32 = @as(i32, @intCast(i)) - 1;
            const movedY: i32 = @as(i32, @intCast(j)) - 1;
            if (pos.x + movedX < 0 or pos.y + movedY < 0) continue;
            if (pos.x + movedX >= GRID_WIDTH or pos.y + movedY >= GRID_HEIGHT) continue;

            if (i == 1 and j == 1) continue;
            const toCheck = pos.translate(movedX, movedY);
            count += grid[_2Dto1D(toCheck)];
        }
    }
    return count;
}

pub export fn step() void {
    zeroesNextGrid();
    for (0..grid.len) |i| {
        const neighbour = countNeighbour(i);
        // Alive and neigbour < 2 = DEAD
        if (grid[i] == 1 and neighbour < 2) {
            next_grid[i] = 0;
        }
        // alive and at least 2 but not more than 3 = ALIVE
        if (grid[i] == 1 and neighbour == 2 or neighbour == 3) {
            next_grid[i] = 1;
        }
        // dead and 3 neigbour = ALIVE
        if (grid[i] == 0 and neighbour == 3) {
            next_grid[i] = 1;
        }
        // alive and neigbour more than 3 = DEAD
        if (grid[i] == 0 and neighbour > 3) {
            next_grid[i] = 0;
        }
    }
    copyGrid();
}

pub export fn init() void {
    var randConfig = std.Random.DefaultPrng.init(random());
    const rand = randConfig.random();
    for (&grid) |*cell| {
        cell.* = if (rand.boolean()) 1 else 0;
    }
    // const initialPos = Vector2D(i32).new(3, 3);
    // grid[initialPos.to1DIndex()] = 1;
    // grid[initialPos.translate(0, -1).to1DIndex()] = 1;
    // grid[initialPos.translate(0, 1).to1DIndex()] = 1;
}

pub export fn getGridPtr() usize {
    const el = &grid[0];
    return @intFromPtr(el);
}
