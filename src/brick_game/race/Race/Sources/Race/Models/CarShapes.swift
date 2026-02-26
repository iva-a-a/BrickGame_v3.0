enum CarShapes {
    // *#* / ### / *#* / ###
    static let player: [Point] = [
        .init(x: 1, y: 0),
        .init(x: 0, y: 1), .init(x: 1, y: 1), .init(x: 2, y: 1),
        .init(x: 1, y: 2),
        .init(x: 0, y: 3), .init(x: 1, y: 3), .init(x: 2, y: 3),
    ]

    // ### / *#* / ### / *#*
    static let enemy: [Point] = [
        .init(x: 0, y: 0), .init(x: 1, y: 0), .init(x: 2, y: 0),
        .init(x: 1, y: 1),
        .init(x: 0, y: 2), .init(x: 1, y: 2), .init(x: 2, y: 2),
        .init(x: 1, y: 3),
    ]

    static let size = (w: 3, h: 4)
}