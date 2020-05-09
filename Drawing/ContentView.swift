//
//  ContentView.swift
//  Drawing
//
//  Created by Pradeep on 05/05/20.
//  Copyright © 2020 Pradeep. All rights reserved.
//

import SwiftUI

struct Arc: Shape {
    
    var startAngle: Angle
    var endAngle: Angle
    var clockWise: Bool
    
    func path(in rect: CGRect) -> Path {
        
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockWise)
        
        return path
    }
    
    
}
struct Traingle: Shape {
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
    
    
}

struct Flower: Shape {
    // How much to move this petal away from the center
    var petalOffset: Double = -20
    
    // How wide to make each petal
    var petalWidth: Double = 100
    
    func path(in rect: CGRect) -> Path {
        // The path that will hold all petals
        var path = Path()
        
        // Count from 0 up to pi * 2, moving up pi / 8 each time
        for number in stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 8) {
            // rotate the petal by the current value of our loop
            let rotation = CGAffineTransform(rotationAngle: number)
            
            // move the petal to be at the center of our view
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            
            // create a path for this petal using our properties plus a fixed Y and height
            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y: 0, width: CGFloat(petalWidth), height: rect.width / 2))
            
            // apply our rotation/position transformation to the petal
            let rotatedPetal = originalPetal.applying(position)
            
            // add it to our main path
            path.addPath(rotatedPetal)
        }
        
        // now send the main path back
        return path
    }
}
/*
 struct ContentView: View {
 
 @State private var petalOffset = -20.0
 @State private var petalWidth = 100.0
 
 var body: some View {
 
 VStack {
 Flower(petalOffset: petalOffset, petalWidth: petalWidth)
 //.fill(Color.red)
 .fill(Color.red, style: FillStyle(eoFill: true))
 
 Text("Offset")
 Slider(value: $petalOffset, in: -40...40)
 .padding([.horizontal, .bottom])
 
 Text("Width")
 Slider(value: $petalWidth, in: 0...100)
 .padding(.horizontal)
 }
 }
 }
 */

struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(self.color(for: value, brightness: 1), lineWidth: 2)
            }
        }
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}


struct ContentView: View {
    
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0
    @State private var colorCycle = 0.0
    @State private var amount: CGFloat = 0.0
    @State private var sliderValue:CGFloat = 0.0
    
    var body: some View {
        
        VStack {
            Image("Example")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 200)
                .saturation(Double(sliderValue))
                .blur(radius: (1 - sliderValue) * 20)
            ZStack{
                Circle()
                    //.stroke(Color.red, lineWidth: 3.0)
                    //.fill(Color.red)
                .fill(Color(red: 1, green: 0, blue: 0))
                    .frame(width: 200 * sliderValue)
                    .offset(x: -80, y: -50)
                    .blendMode(.screen)
                
                Circle()
                    //.stroke(Color.blue, lineWidth: 3.0)
                    //.fill(Color.green)
                    .fill(Color(red: 0, green: 1, blue: 0))
                    .frame(width: 200 * sliderValue)
                    .offset(x: 80, y: -50)
                    .blendMode(.screen)
                
                Circle()
                    //.fill(Color.blue)
                    //.stroke(Color.yellow, lineWidth: 3.0)
                    .fill(Color(red: 0, green: 0, blue: 1))
                    .frame(width: 200 * sliderValue)
                    .blendMode(.screen)
                
            }
            .frame(width: 300, height: 300)
            
            
            Slider(value: $sliderValue)
                .padding()
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
