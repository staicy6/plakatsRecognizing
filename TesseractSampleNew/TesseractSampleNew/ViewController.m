//
//  ViewController.m
//  TesseractSampleNew
//
//  Created by Anastasia Uryasheva on 1/31/13.
//  Copyright (c) 2013 Anastasia Uryasheva. All rights reserved.
//

#import "tesseract.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    [tesseract setImage:[UIImage imageNamed:@"image_sample.jpg"]];
    [tesseract recognize];
    
    NSLog(@"%@", [tesseract recognizedText]);
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
