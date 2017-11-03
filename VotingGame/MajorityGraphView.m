//
//  MajorityGraphView.m
//  VotingGame
//
//  Created by Xavier Zhu on 16/4/5.
//  Copyright © 2016年 Xian Zhu. All rights reserved.
//

#import "MajorityGraphView.h"
#define RADIUS 300
#define SMALLRADIUS 45


@implementation MajorityGraphView




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.5);
    CGFloat screenHeight = self.bounds.size.height;
    CGFloat screenWidth = self.bounds.size.width;

    CGPoint centerPoint= CGPointMake(screenWidth/2, screenHeight/2);

    int n=self.number;
    CGPoint points[n];
    CGPoint point=CGPointMake(screenWidth/2, screenHeight/2-RADIUS);

    points[0]=point;
    //Draw the first circle
    CGContextAddArc(context, screenWidth/2, screenHeight/2-RADIUS, SMALLRADIUS, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);
    CGContextDrawPath(context, kCGPathStroke);
    
    //Draw the first Applicant's name
    CGFloat angle= 2*M_PI/n;
    NSString *str=[self.applicantsName objectAtIndex:0];
    UIFont *font =[UIFont fontWithName:@"American Typewriter" size:25];
    CGFloat fontHeight= font.pointSize;
       double a=M_PI/4;
    CGRect textRect=CGRectMake(points[0].x-sin(a)*SMALLRADIUS, points[0].y-fontHeight/2, 2*sin(a)*SMALLRADIUS,  fontHeight);
    [self drawString:str withFont:font inRect:textRect];
    
    
    //Draw the left circle and names
    for(int i=0; i<n-1;i++){
        
    CGFloat a=[self getPointFromCirclewithRadius:RADIUS CenterPoint:centerPoint OnePoint:points[i] andAngle:angle].x;
    CGFloat b=[self getPointFromCirclewithRadius:RADIUS CenterPoint:centerPoint OnePoint:points[i] andAngle:angle].y;
    points[i+1] = CGPointMake(a, b);
        
    CGContextAddArc(context, a, b, SMALLRADIUS, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);

    CGContextDrawPath(context, kCGPathStroke);
        
    str =[self.applicantsName objectAtIndex:i+1];
    
    textRect=CGRectMake(points[i+1].x-sin(a)*SMALLRADIUS, points[i+1].y-fontHeight/2, 2*sin(a)*SMALLRADIUS,  fontHeight);
        
    [self drawString:str withFont:font inRect:textRect];
        
    }
    
    NSMutableArray *count =[NSMutableArray arrayWithCapacity:n];
    for (int i=0; i<n; i++) {
        [count addObject:@0];
    }
    int index=0;
    for (int i = 0; i < n-1; i++) {
        for (int j=i+1; j<n; j++) {
            NSInteger mark =[[self.mark objectAtIndex:index]integerValue];
            NSInteger voterNumber= self.voters.count;
            if(mark>0){
                [self drawArrow:context from:points[i] to:points[j]];
                int c =[[count objectAtIndex:i]intValue];
                c++;
                [count replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:c]];
            }
            else if(mark<0){
                [self drawArrow:context from:points[j] to:points[i]];
                int c =[[count objectAtIndex:j]intValue];
                c++;
                [count replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:c]];
            }
            float q =(float) ((mark +voterNumber)/2)/voterNumber;
            NSString *firstApplicantName = [self.applicantsName objectAtIndex:i];
            NSString *secondApplicantName = [self.applicantsName objectAtIndex:j];
            NSString *string = [NSString stringWithFormat:@"%.2f%% of voters supports %@>%@",q*100,firstApplicantName,secondApplicantName];
            font =[UIFont fontWithName:@"American Typewriter" size:15];
            if(q==0.50){
                font=[UIFont boldSystemFontOfSize:15];
                [self drawString:string withFont:font withColor:[UIColor redColor]atPoint:CGPointMake(10,800+index*17)];
            }
            else
            [self drawString:string withFont:font withColor:[UIColor blackColor]atPoint:CGPointMake(10,800+index*17)];
            index++;
        }
    }
    
    for (int i=0; i<n; i++) {
        if ([[count objectAtIndex:i]intValue] == n-1) {
            font=[UIFont boldSystemFontOfSize:15];
            NSString *string = [NSString stringWithFormat:@"Candidate \"%@\" is a Condorcet winner",[self.applicantsName objectAtIndex:i]];
            [self drawString:string withFont:font withColor:[UIColor redColor]atPoint:CGPointMake(480,820)];
        };
    }

    
}



-(void) drawString:(NSString*) s
          withFont:(UIFont*)font
         withColor: (UIColor*)color
           atPoint:(CGPoint)point{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSForegroundColorAttributeName: color,
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    [s drawAtPoint:point withAttributes:attributes];
}

- (void) drawArrow: (CGContextRef) context from: (CGPoint) from to: (CGPoint) to
{
    
    CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);
    double slopy, cosy, siny;
    double l=SMALLRADIUS;
    // Arrow size
    double length = 20.0;
    double width = 20.0;
    
    slopy = atan2((from.y - to.y), (from.x - to.x));
    cosy = cos(slopy);
    siny = sin(slopy);
    
    //draw a line between the 2 endpoint
    CGContextMoveToPoint(context, from.x - l * cosy, from.y - l * siny );
    CGContextAddLineToPoint(context, to.x +length * cosy+ l * cosy, to.y + length * siny +l * siny);
    //paints a line along the current path
    CGContextStrokePath(context);
    
    
    CGContextMoveToPoint(context, to.x + l * cosy, to.y + l * siny);
    CGContextAddLineToPoint(context,
                            to.x + l * cosy+  (length * cosy - ( width / 2.0 * siny )),
                            to.y + l * siny+  (length * siny + ( width / 2.0 * cosy )) );
    CGContextAddLineToPoint(context,
                            to.x + l * cosy +  (length * cosy + width / 2.0 * siny),
                            to.y + l * siny-  (width / 2.0 * cosy - length * siny) );
    CGContextClosePath(context);
    CGContextStrokePath(context);
}


- (void) drawString: (NSString*) s
           withFont: (UIFont*) font
             inRect: (CGRect) contextRect {
    
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSForegroundColorAttributeName: [UIColor blackColor],
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    CGSize size = [s sizeWithAttributes:attributes];
    
    CGRect textRect = CGRectMake(contextRect.origin.x + floorf((contextRect.size.width - size.width) / 2),
                                 contextRect.origin.y + floorf((contextRect.size.height - size.height) / 2),
                                 size.width,
                                 size.height);
    
    [s drawInRect:textRect withAttributes:attributes];
}


-(CGPoint)getPointFromCirclewithRadius: (CGFloat)r CenterPoint: (CGPoint) c OnePoint: (CGPoint) a andAngle:(CGFloat) angle{
    
    CGFloat x,y;
    CGFloat m=c.x;
    CGFloat n=c.y;
    CGFloat X0=a.x;
    CGFloat Y0=a.y;
    x=m+(X0-m)*cos(angle)-(Y0-n)*sin(angle);
    y=n+(X0-m)*sin(angle)+(Y0-n)*cos(angle) ;
    CGPoint point =CGPointMake(x, y);
    return  point;
}

@end
