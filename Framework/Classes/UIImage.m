//  Created by Sean Heber on 5/27/10.
#import "UIImage.h"
#import "_UIThreePartImage.h"
#import "_UINinePartImage.h"
#import "UIGraphics.h"
#import <AppKit/NSImage.h>

@implementation UIImage

- (id)_initWithNSImage:(NSImage *)theImage
{
	return [self initWithCGImage:[theImage CGImageForProposedRect:NULL context:NULL hints:nil]];
}

- (id)initWithData:(NSData *)data
{
	return [self _initWithNSImage:[[[NSImage alloc] initWithData:data] autorelease]];
}

- (id)initWithContentsOfFile:(NSString *)path
{
	return [self _initWithNSImage:[[[NSImage alloc] initWithContentsOfFile:path] autorelease]];
}

- (id)initWithCGImage:(CGImageRef)imageRef
{
	if (!imageRef) {
		[self release];
		return nil;
	} else if ((self=[super init])) {
		_image = imageRef;
		CGImageRetain(_image);
	}
	return self;
}

- (void)dealloc
{
	if (_image) CGImageRelease(_image);
	[super dealloc];
}

+ (UIImage *)imageNamed:(NSString *)name
{
	return [[[self alloc] _initWithNSImage:[NSImage imageNamed:name]] autorelease];
}

+ (UIImage *)imageWithData:(NSData *)data
{
	return [[[self alloc] initWithData:data] autorelease];
}

+ (UIImage *)imageWithContentsOfFile:(NSString *)path
{
	return [[[self alloc] initWithContentsOfFile:path] autorelease];
}

+ (UIImage *)imageWithCGImage:(CGImageRef)imageRef
{
	return [[[self alloc] initWithCGImage:imageRef] autorelease];
}

+ (UIImage *)_frameworkImageNamed:(NSString *)name
{
	NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:@"com.iconfactory.UIKit"];
	NSString *frameworkFile = [[frameworkBundle resourcePath] stringByAppendingPathComponent:name];
	return [self imageWithContentsOfFile:frameworkFile];
}

- (UIImage *)stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight
{
	const CGSize size = self.size;
	if ((leftCapWidth == 0 && topCapHeight == 0) || (leftCapWidth >= size.width && topCapHeight >= size.height)) {
		return self;
	} else if (leftCapWidth <= 0 || leftCapWidth >= size.width) {
		return [[[_UIThreePartImage alloc] initWithNSImage:[[[NSImage alloc] initWithCGImage:_image size:NSZeroSize] autorelease] capSize:MIN(topCapHeight,size.height) vertical:YES] autorelease];
	} else if (topCapHeight <= 0 || topCapHeight >= size.height) {
		return [[[_UIThreePartImage alloc] initWithNSImage:[[[NSImage alloc] initWithCGImage:_image size:NSZeroSize] autorelease] capSize:MIN(leftCapWidth,size.width) vertical:NO] autorelease];
	} else {
		return [[[_UINinePartImage alloc] initWithNSImage:[[[NSImage alloc] initWithCGImage:_image size:NSZeroSize] autorelease] leftCapWidth:leftCapWidth topCapHeight:topCapHeight] autorelease];
	}
}

- (void)drawAtPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
	CGSize size = self.size;
	[self drawInRect:CGRectMake(point.x,point.y,size.width,size.height) blendMode:blendMode alpha:alpha];
}

- (void)drawInRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSaveGState(ctx);
	CGContextTranslateCTM(ctx, rect.origin.x, rect.origin.y+rect.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	CGContextSetBlendMode(ctx, blendMode);
	CGContextDrawImage(ctx, CGRectMake(0,0,rect.size.width,rect.size.height), _image);
	CGContextRestoreGState(ctx);
}

- (void)drawAtPoint:(CGPoint)point
{
	[self drawAtPoint:point blendMode:kCGBlendModeNormal alpha:1];
}

- (void)drawInRect:(CGRect)rect
{
	[self drawInRect:rect blendMode:kCGBlendModeNormal alpha:1];
}

- (CGSize)size
{
	return CGSizeMake(CGImageGetWidth(_image), CGImageGetHeight(_image));
}

- (NSInteger)leftCapWidth
{
	return 0;
}

- (NSInteger)topCapHeight
{
	return 0;
}

- (CGImageRef)CGImage
{
	return _image;
}

- (UIImageOrientation)imageOrientation
{
	return UIImageOrientationUp;
}

@end

void UIImageWriteToSavedPhotosAlbum(UIImage *image, id completionTarget, SEL completionSelector, void *contextInfo)
{
}

NSData * UIImageJPEGRepresentation(UIImage *image, CGFloat compressionQuality)
{
	return nil;
}