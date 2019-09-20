//
//  ViewController.swift
//  benchmark
//
//  Created by Eliot Andres on 9/20/19.
//  Copyright © 2019 Eliot Andres. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    var inputData: CVPixelBuffer?
    let deeplab = DeepLab()
    let size = 513
    let numRuns = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: #selector(startBenchmark), for: .touchUpInside)
        label.text = ""

        let image = #imageLiteral(resourceName: "cat.jpg")
        self.inputData = image.pixelBuffer(width: size, height: size)
    }

    @objc func startBenchmark() {
        label.text = "Loading..."
        DispatchQueue.global(qos: .userInitiated).async {
            self.benchmark()
        }

    }

    func benchmark() {
        let start = Date()

        for i in 1...numRuns {
            do {
                print(i)
                let result = try deeplab.prediction(image: self.inputData!)
            } catch let error {
                print(error.localizedDescription)
            }

        }

        let end = Date()
        let executionTime = end.timeIntervalSince(start)
        let imagesPerSecond = Double(numRuns) / executionTime

        DispatchQueue.main.async {
            self.label.text = String(format: "%.2f images/second", imagesPerSecond)
        }
    }

}

