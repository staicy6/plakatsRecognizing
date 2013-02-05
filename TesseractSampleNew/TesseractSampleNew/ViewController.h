//
//  ViewController.h
//  TesseractSampleNew
//
//  Created by Anastasia Uryasheva on 1/31/13.
//  Copyright (c) 2013 Anastasia Uryasheva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
	UIImageView * imageView;
	UIButton * choosePhotoBtn;
	UIButton * takePhotoBtn;
    UIButton * analyzeButton;
    UIButton * calendarButton;
    Tesseract* tesseract;
    UIImage *nnewImage;
    EKEventStore * store;
    EKEvent * ourEvent;
    EKCalendar * ourCalendar;
    NSArray *monthArray;
    NSString *montName;
    NSUInteger *dayName;
    NSString *mmonthName;
    NSArray *timeArray;
    int amountOfHours;
    NSMutableArray *hoursAm;
    NSMutableArray *resu;
    NSString * titlestring;
}

@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UIButton * choosePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton * takePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton * analyzeButton;
@property (nonatomic, retain) IBOutlet UIButton * calendarButton;
@property (nonatomic, retain) IBOutlet UIImage * nnewImage;
@property (nonatomic, retain) IBOutlet EKEventStore * store;
@property (nonatomic, retain) IBOutlet EKCalendar * ourCalendar;
@property (nonatomic, retain) IBOutlet EKEvent * ourEvent;
@property (nonatomic, retain) IBOutlet NSArray * monthArray;
@property (nonatomic, retain) IBOutlet NSMutableArray * hoursAm;
@property (nonatomic, retain) IBOutlet NSString * monthName;
@property (nonatomic, retain) IBOutlet NSString * mmonthName;
@property (nonatomic) NSUInteger * dayName;
@property (nonatomic) int  amountOfHours;
@property (nonatomic, retain) IBOutlet NSArray * timeArray;
@property (nonatomic, retain) IBOutlet NSMutableArray * resu;
@property (nonatomic, retain) IBOutlet NSString * titlestring;

-(IBAction) getPhoto:(id) sender;
-(IBAction) analyze:(id) sender;
-(IBAction) calendarOlo:(id)sender;
-(void) writeResultToFile:(NSString*) str;
-(NSString *) readStringFromFile: (NSString*) nameOfFile;
-(void)takeDateFromTxt: (NSString*) str;
-(void)takeTimeFromTxt: (NSString*) str;
- (BOOL)imageFunc:(UIImage *)image1 isEqualTo:(UIImage *)image2;
//-(void) saveToJpg:(UIImage *)image1;

@end
