//
//  CsvFile.swift
//  Blendshape2Robot
//
//  Created by liu on 2023/03/06.
//

import Foundation
import simd

class CsvFile {
    private var faceBlendShapes: [[Float]] = [[]]
    private var faceMeshX: [[Float]] = [[]]
    private var faceMeshY: [[Float]] = [[]]
    private var faceMeshZ: [[Float]] = [[]]
    
    func update_blendshape(_ blendshape: [Float]) {
        faceBlendShapes.append(blendshape)
    }
    
    func update_mesh(_ meshVertices: [vector_float3]) {
        var verticesX = [Float](repeating: 0.0, count: meshVertices.count)
        var verticesY = [Float](repeating: 0.0, count: meshVertices.count)
        var verticesZ = [Float](repeating: 0.0, count: meshVertices.count)
        for (idx, vertex) in zip(meshVertices.indices, meshVertices) {
            verticesX[idx] = vertex.x
            verticesY[idx] = vertex.y
            verticesZ[idx] = vertex.z
        }
        faceMeshX.append(verticesX)
        faceMeshY.append(verticesY)
        faceMeshZ.append(verticesZ)
    }
    
    func save_csv(dataArr: [[Float]], filename: String) {
        DispatchQueue.global(qos: .background).async {
            let dirUrl = try! FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false)
            let fileUrl = dirUrl.appendingPathComponent(filename)
            var dataString: String = ""
            do {
                for row in dataArr {
                    for (idx, val) in zip(row.indices, row) {
                        var sep: String
                        if idx < row.count - 1 {
                            sep = ", "
                        } else {
                            sep = "\n"
                        }
                        dataString += String(format: "%.3f", val) + sep
                    }
                }
                try dataString.write(to: fileUrl, atomically: true, encoding: .utf8)
            } catch {
                print("file saving error")
            }
        }
    }
    
    func save_test_data() {
        save_csv(dataArr: faceBlendShapes, filename: "blendshapes.csv")
        save_csv(dataArr: faceMeshX, filename: "mesh_x.csv")
        save_csv(dataArr: faceMeshY, filename: "mesh_y.csv")
        save_csv(dataArr: faceMeshZ, filename: "mesh_z.csv")
    }
}
