/**
 * Interface description file for the API of ZLP-Service.
 * This file is processed by the Thrift generator to produce code for various target languages.
 * For more information about Apache Thrift see https://thrift.apache.org.
 */

namespace py zlaser.thrift
namespace cpp zlaser.thrift

const string apiVersionHash = "39a49a2040"

const i32 apiMajorVersion = 4
const i32 apiMinorVersion = 0
const i32 apiPatchVersion = 0

/** Default port of ZLP-Service to listen for client connections. */
const i32 defaultPort = 9090

/** Semantic version number */
struct Version
{
    1: required i32 major,
    2: i32 minor = 0,
    3: i32 patch = 0,
}

enum ProjectorType_t
{
    UNKNOWN,
    A2F500SOM,
    ZLP1,
    ZLP2,
    SIMULATOR,
}

struct TeachTable_t
{
    1: required double minX,
    2: required double maxX,
    3: required double minY,
    4: required double maxY,
}

struct ProjectorInfo_t
{
    1: required Version hwRevision,
    2: required Version fpgaIp,
    3: required Version firmware,
    4: required Version lpcom,
    5: required string revision,
    6: required ProjectorType_t kind,
    7: required TeachTable_t teachTable,
}

/** Defines set types for clip groups to decide visibility of elements/segments. */
enum ClipSetTypes
{
    /** Element is visible if all clipping results left it visible */
    Intersection,

    /** Element is visible if at least one clipping result left it visible */
    Union,
}

/** Element types in GeoTree data structure */
enum GeoTreeElemTypes
{
    /** unspecified or unknown element type */                              UNSPECIFIED_BASE    = 0x00000,
    /** Bit to identify enum as a mask for class of elements */             MASK_BIT            = 0x10000,
    /** Mask for the element type bits */                                   TYPE_MASK           = 0x0FF00,
    /** for use in GetElementIds to get all element types */                ALL_TYPE            = 0x1FF00,
    /** Type for all groups */                                              GROUP_TYPE          = 0x10100,
    /** A group for all types of elements, should be in ALL, GROUP */       EL_GROUP            = 0x00100,
    /** Flag for all 3D elements (includes projectable and clip types) */   EL_3D_TYPE          = 0x10200,
    /** Group for 3D element, should be in ALL, GROUP, EL_3D */             GROUP_3D            = 0x00300,

    /** Flag for all projectable elements */                                PROJECTION_EL_TYPE  = 0x10400,
                                                                            POLYLINE            = 0x00400,
                                                                            CIRCLESEGMENT       = 0x00401,
                                                                            TEXTELEMENT         = 0x00402,
                                                                            OVALSEGMENT         = 0x00403,

    /** Flag for all clipping type elements */                              CLIP_EL_TYPE        = 0x10800,
                                                                            CLIPPLANE           = 0x00800,
                                                                            CLIP_GROUP          = 0x00900,

    /** Reference object */                                                 REFOBJECT           = 0x01000,
                                                                            DRIFT_COMPENSATION  = 0x02001,
                                                                            CLIP_RECT           = 0x04000,
}

/** Function module state values as they are returned by FunctionModuleGetState() */
enum FunctionModuleStates
{
    /** Initial state of the ZLP-Service / initializing */
    UNITIALIZED,

    /** Waiting for start of a function module */
    IDLE,

    /** Function module is running */
    RUNNING,

    /** Stop was requested for a running function module */
    STOP_REQUESTED,

    /** Error occurred, but module can be started again. Error can be retrieved by FunctionModuleGetErrorString(). */
    RECOVERABLE_ERROR,

    /** Serious error occurred. Error can be retrieved by FunctionModuleGetErrorString(). */
    CRITICAL_ERROR,
}

/** Command codes of remote control functions */
enum RcCommandCodes
{
    KEY_FOCUS_IN = 1,
    KEY_ON_OFF = 3,
    KEY_MODE = 4,
    KEY_PLUS = 5,
    KEY_FOCUS_OUT = 6,

    KEY_MINUS = 10,

    KEY_UP_LEFT = 17,
    KEY_UP = 18,
    KEY_UP_RIGHT = 19,

    KEY_LEFT = 22,
    KEY_HOME = 23,
    KEY_RIGHT = 24,

    KEY_DOWN_LEFT = 27,
    KEY_DOWN = 28,
    KEY_DOWN_RIGHT = 29,

    KEY_ROTATE_LEFT = 32,

    KEY_ROTATE_RIGHT = 34,

    KEY_SEARCH = 38,

    KEY_P1_P9 = 46,
    KEY_P2_P10 = 47,
    KEY_P3_P11 = 48,
    KEY_P4_P12 = 49,
    KEY_ALL = 50,
    KEY_P5_P13 = 51,
    KEY_P6_P14 = 52,
    KEY_P7_P15 = 53,
    KEY_P8_P16 = 54,
    KEY_2ND = 55,
}

/** Parameters for transformation function */
enum ReferencePlane
{
    PLANE_YZ = 1,
    PLANE_XZ = 2,
}

enum MarkerType
{
    /** Square in the curved galvo coordinate system with an upright cross at the center */
    searchArea,
    horizontalCross,
    diagonalCross,
    square,
    circle,
}

struct Vector2D
{
    1: required double x,
    2: required double y,
}

struct Vector3D
{
    1: required double x,
    2: required double y,
    3: required double z,
}

typedef Vector3D Point3D
typedef Vector2D Point2D

/** RGB color value */
struct RGBValue
{
    /** Red */
    1: required i16 r,

    /** Green */
    2: required i16 g,

    /** Blue */
    3: required i16 b,
}

/** Represents a 4x4 matrix, as a list of rows.*/
struct Matrix4x4
{
    1: required list<list<double>> data,
}

/** Base structure for GeoTree elements */
struct GeoTreeElement
{
    /** complete element path (group/group/element) */
    1: required string name,

    /** Flag for activation, visualisation */
    2: required bool activated = true,

    3: GeoTreeElemTypes type,
}

/** Base clipping element for multi projector systems */
struct ClipElement
{
    /** complete element path (group/group/element) */
    1: required string name,

    /** Flag for activation, visualisation */
    2: required bool activated = true,

    /** map of projector associated value to decide whether to project */
    3: required map<string, bool> projectorMap,

    /** name of corresponding coordinate system */
    4: required string coordinateSystem,
}

/** Clipping plane for multi projector systems.
Map contains all associated projectors as Key(string) and a Flag as Value(boolean).
The Flag describes, if the facing (0) or the averted side (1) is projected by the associated projector.
*/
struct ClipPlane
{
    /** complete element path (group/group/element) */
    1: required string name,

    /** Flag for activation, visualisation */
    2: required bool activated = true,

    /** map of projector associated value to decide whether to project */
    3: required map<string, bool> projectorMap,

    /** name of corresponding coordinate system */
    4: required string coordinateSystem,

    /** point of plane in Point-Normal-Form */
    5: required Point3D point,

    /** normal of plane in Point-Normal-Form */
    6: required Point3D normal,
}

/** Rectangle for clipping the projection data */
struct ClipRect
{
    /** complete element path (group/group/element) */
    1: required string name,

    /** Flag for activation */
    2: required bool activated = true,

    /** Flag for visualisation */
    3: required bool showOutline = false,

    /** Flag for activation of clipping */
    4: required bool clippingActivated = false,

    /** Position of lower left corner of the element */
    5: required Point3D position,

    /** height, width of element */
    6: required Vector2D size,

    /** name of corresponding coordinate system */
    7: required string coordinateSystem,
}

/** Base structure for 3d elements */
struct Element3d
{
    /** complete element path (group/group/element) */
    1: required string name,

    /** Flag for activation, visualisation */
    2: required bool activated = true,

    /** User transformation */
    3: required Matrix4x4 userTrans,

    4: GeoTreeElemTypes type,
}

/** Base structure for all types of projection elements e.g text, circle, polyline, etc. */
struct ProjectionElement
{
    /** complete element path (e.g. "group/group/element") */
    1: required string name,

    /** enable or disable projection */
    2: required bool activated = true,

    /** user transformation */
    3: required Matrix4x4 userTrans,

    /** pen number */
    4: required i16 pen,

    /** list of coordinate systems */
    5: required list<string> coordinateSystemList,

    /** list of projectors */
    6: required list<string> projectorIDList,

    /** enable or disable reflection detection */
    7: optional bool detectReflection = false,

    /** expected reflection state at the beginning of projection */
    8: optional bool initialReflectionState = false,

    /** reflection state detected by the projector */
    9: optional bool currentReflectionState = false,

    10: GeoTreeElemTypes type,
}

/** Polyline element, consists of a set of polylines described by the inner list of 3d points in the polylineList field.
A cross for example, consists of two disconnected polylines. The polylineList field does not describe the segments of
the polyline. But rather a group of polylines that constitutes the element.
*/
struct Polyline
{
    /** complete element path (group/group/element) */
    1: required string name,

    /** Flag for activation, visualisation */
    2: required bool activated = true,

    /** User transformation */
    3: required Matrix4x4 userTrans,

    /** Pen number, color to use */
    4: required i16 pen,

    /** List of coordinate systems */
    5: required list<string> coordinateSystemList,

    /** List of projectors */
    6: required list<string> projectorIDList,

    /** enable or disable reflection detection */
    7: optional bool detectReflection = false,

    /** expected reflection state at the beginning of projection */
    9: optional bool initialReflectionState = false,

    /** reflection state detected by the projector */
    10: optional bool currentReflectionState = false,

    /** List of polylines */
    8: required list<list<Point3D>> polylineList,
}

/** CircleSegment element describes an Arc or Circle in 3d space. */
struct CircleSegment
{
    /** Element path (group/group/element) */
    1: required string name,

    2: required bool activated = true,
    3: required Matrix4x4 userTrans,
    4: required i16 pen,
    5: required list<string> coordinateSystemList,

    /** List of projectors */
    6: required list<string> projectorIDList,

    /** Enable or disable reflection detection */
    7: optional bool detectReflection = false,

    /** Expected reflection state at the beginning of projection */
    14: optional bool initialReflectionState = false,

    /** Reflection state detected by the projector */
    15: optional bool currentReflectionState = false,

    8: required Point3D center,
    9: required double radius,

    /** Start angle in degree. If not set and endAngle is set, defaults to 0°. */
    11: optional double startAngle,

    /** End angle in degree. If not set and startAngle is set, defaults to 360°.
    If both start/endAngle are not set the element is a circle */
    12: optional double endAngle,

    /** Normal vector of drawing plane. If placed in the XY plane, normal might not be set. */
    13: optional Vector3D normal,
}

struct TextElement
{
    /** complete element path (group/group/element) */
    1: required string name,

    /** Flag for activation, visualisation */
    2: required bool activated = true,

    /** User transformation */
    3: required Matrix4x4 userTrans,

    /** Pen number, color to use */
    4: required i16 pen,

    /** List of coordinate systems */
    5: required list<string> coordinateSystemList,

    /** List of projectors */
    6: required list<string> projectorIDList,

    /** enable or disable reflection detection */
    7: optional bool detectReflection = false,

    /** expected reflection state at the beginning of projection */
    16: optional bool initialReflectionState = false,

    /** reflection state detected by the projector */
    17: optional bool currentReflectionState = false,

    8: required Point3D position,
    9: required string text,
    10: required double height,

    /** Name or path of font */
    11: optional string font,

    /** Normal vector of drawing plane, to render text */
    12: optional Vector3D normal,

    /** Rotation angle in degree */
    13: optional double angle,

    /** Space between characters */
    14: optional double charSpacing,

    /** Space between lines */
    15: optional double lineSpacing,
}

struct OvalSegment
{
    /** complete element path (group/group/element) */
    1: required string name,

    /** Flag for activation, visualisation */
    2: required bool activated = true,

    /** User transformation */
    3: required Matrix4x4 userTrans,

    /** Pen number, color to use */
    4: required i16 pen,

    /** List of coordinate systems */
    5: required list<string> coordinateSystemList,

    /** List of projectors */
    6: required list<string> projectorIDList,

    /** enable or disable reflection detection */
    7: optional bool detectReflection = false,

    /** expected reflection state at the beginning of projection */
    16: optional bool initialReflectionState = false,

    /** reflection state detected by the projector */
    17: optional bool currentReflectionState = false,

    8: required Point3D center,
    9: required double width,
    10: optional double height,
    11: optional double angle,

    /** Difference in mm between oval and chord */
    12: optional double chordHeight,

    /** StartAngle in degree */
    13: optional double startAngle,

    /** EndAngle in degree */
    14: optional double endAngle,

    /** Normal Vector of drawing plane, to draw oval */
    15: optional Vector3D normal,
}

struct Referencepoint
{
    /** Identifier */
    1: required string name,

    /** Use point for projector setup */
    2: required bool activated = true,

    /** 3D world coordinate */
    3: required Point3D refPoint,

    /** Intital 2D trace point in mm */
    4: required Point2D tracePoint,

    /** Width and height of search area in mm */
    5: required Point2D crossSize,

    /** Distance to projector in mm */
    6: required double distance,
}

/** Reference object is used for assignment of coordinate system to a projector via a transformation
which is calculated from reference points. Reference object is deactivated by default to prevent usage
if transformation matrix is not calculated.
*/
struct Referenceobject
{
    /** complete element path (group/group/element) */
    1: required string name,

    /** Flag for activation, visualisation */
    2: required bool activated = false,

    /** Calculated field transformation from 3D-Setup */
    3: required Matrix4x4 fieldTransMat,

    /** List of initial reference points */
    4: required list<Referencepoint> refPointList,

    /** ID of the projector that uses the transformation */
    5: required string projectorID,

    /** Name of the corresponding coordinate system */
    6: required string coordinateSystem,
}

/** Group of elements (branch) in the GeoTree */
struct GeoTreeGroup
{
    /** complete element path (group/group/element) */
    1: required string name,

    /** Flag for activation, visualisation */
    2: required bool activated = true,
}

/** 3d group is a group with additional properties for 3d elements */
struct Group3d
{
    /** complete element path (group/group/element) */
    1: required string name,

    /** Flag for activation, visualisation */
    2: required bool activated = true,

    /** User transformation */
    3: required Matrix4x4 userTrans,
}

/** Group element for clipping, should be extended by clip element properties */
struct ClipGroup
{
    /** complete element path (group/group/element) */
    1: required string name,

    /** Flag for activation, visualisation */
    2: required bool activated = true,

    /** map of projector associated value to decide whether to project */
    3: required map<string, bool> projectorMap,

    /** name of corresponding coordinate system */
    4: required string coordinateSystem,

    /** Type of set to decide visibility of group elements */
    5: required ClipSetTypes setType,
}

/** Identification of geometry data (e.g. groups, polylines, circle, etc.).
modificationTimeStamp is used for synchronisation purposes. Each time the element is modified, the modification time
stamp is updated. By doing so the client can check, whether it has to reload the data.
*/
struct GeoTreeElemId
{
    /** name e.g. Group1/Group2/Polyline1 */
    1: required string name,

    2: required GeoTreeElemTypes elemType,
    3: required i64 modificationTimeStamp,
}

/** Id of command for getting list of remote control commands */
struct RcCommandId
{
    /** Mode of RC. */
    1: required i16  mode,

    /** Command of the IR frame. */
    2: required i16  cmd,

    /** Second key activated by RC */
    3: optional bool second = false,
}

struct SignalCollectorParameters
{
    /** Receive remove control signals */
    1: required bool remoteControl = true,

    /** Receive reflection detection signals */
    2: required bool reflectionDetection = true,

    /** Polling interval in ms [min: 50, max: 500] */
    3: required i16 signalCollectionInterval = 100,

    /** Signal level threshold for the reflection detection sensor [min: 1, max: 50] */
    4: required i16 refDetThreshold = 5,

    /** number of repetitions of identical reflection detections required for a valid detection [min: 0, max: 10] */
    5: required i16 frameRepThreshold = 3,
}

/** Parameters to control management of projector connections */
struct ProjectorConnectionParameters
{
    /** Time interval in seconds to check the projector connection. The parameter also defines how often the projector
    state and the projector measurements are updated in case 'updateState' and 'updateMeasurements' are active. */
    1: optional i16 watchInterval,

    /** Update projector state periodically: link state, over temperature, laser source, movement detection, interlock,
    shutter, etc.. If the parameter is set to false, the heartbeat mechanism is also deactivated. A projector keeps its
    link state to a ZLP-Service instance and keeps on projecting even if the ZLP-Service is not active anymore.
    However, if the parameter is true, the heartbeat meachanism is active and the projector resets its link state and
    stops projecting automatically whenever the ZLP-Service is not communicating anymore. */
    2: optional bool updateState,

    /** Update projector measurements periodically: temperature, pressure, humidity */
    3: optional bool updateMeasurements,

    /** Maximum number of consecutive connections attempts */
    4: optional i16 maxConnectionAttempts,

    /** Time interval in seconds to start new series of connection attempts */
    5: optional i16 connectionAttemptsInterval,

    /** Check before every call to the projector, if it is still reachable.
    Deactivating this option is only recommended for dynamic projection applications since it may cause the system
    to freeze in case of connection problems. */
    6: optional bool checkConnection,

    /** If a projector is not reachable within the given time in milliseconds, the connection check will fail.
    Increase the value if you experience the following error: LP_ERROR_CHECK_ADDRESS_TIMEOUT. */
    7: optional i16 checkConnectionTimeout,
}

/** General parameters to control the projection generation process. */
struct GlobalProjectionParameters
{
    /** This parameter limits the maximum number of projection cycles per second. */
    1: optional double maxProjectionRate,

    /** When the direction of the projection path changes by at least the given angle in degree,
    the galvos stop at this position and the laser is turned off for at least one tick.
    A high value reduces flicker but may lead to round corners. */
    2: optional double cornerDetectionAngle,

    /** The projection is simplified in the path generation process by deleting original points which have little
    effect on the final projection shape. This procedure can be influenced by setting the maximum distance between the
    original projection path and its approximation at the the distance of the FCW plane.
    A high value leads to less flicker but reduces geometric accuracy. */
    3: optional double maxApproximationDistance,

    /** This parameter defines the maximum additional deviation to the projection path at the distance of the FCW plane
    because of sampling. A high value leads to less flicker but reduces geometric accuracy. */
    4: optional double maxSamplingDeviation,

    /** Turn the advanced path optimization on or off. The algorithm changes the direction and order of
    projection elements and removes duplicated and overlapping segments. Active optimization increases
    the projection rate but also the calculation time for each projection. */
    5: optional bool pathOptimization,

    /** Path optimization parameter: reduce collinear edges. */
    6: optional bool collinearEdgeFusion,
}

/** Projector-specific parameters to control the projection generation process. */
struct ProjectionParameters
{
    /** The projection path is sampled with the given temporal resolution in microseconds. A low value leads to more
    sampling points and a higher geometric accuracy. A high value reduces the number of galvo positions,
    which need to be send to the projector and enables a faster projection update. */
    1: optional i32 tickTime,

    /** This parameter defines the maximum galvo speed in [µrad/µs] while the laser is turned on.
    A low value increases the brightness of long projection segments but reduced the projection frequency.
    A high value leads to a more stable projection with less flicker but reduces brightness of long segments. */
    2: optional double maxLaserOnSpeed,

    /** This parameter defines the maximum galvo speed in [µrad/µs] while the laser is turned off.
    A high value increases the projection frequency and reduces flicker. */
    3: optional double maxLaserOffSpeed,

    /** This parameter defines the maximum galvo acceleration in [µrad/µs²].
    A high value leads to a more stable projection but decreases geometric accuracy.
    A small value leads to a brighter projection but may increase flicker. */
    4: optional double maxAcceleration,

    /** The synchronization between galvo position and laser modulation is not perfect. This circumstance may lead to
    projection artifacts at line endings and corners. These artifacts can be reduced by setting a synchronization delay
    at theses positions. The delay value is in microseconds and should by a multiple of the given tick time.
    The delay should be as low as possible, since it reduces the projection frequency. */
    5: optional i32 syncDelay,

    /** This parameter enables multi-color projections for projectors with multiple laser modules (e.g. red + green). */
    6: optional bool multiColor,
}

/** Reference point used for drift compensation.
A drift compensation (dc) point is a fixed point in the projection area. It must be visible by the projector and can
optionally have a reflective center. */
struct DriftCompensationPoint
{
    /** Optional identifier */
    1: string name = "",

    /** A dc point can be excluded from drift compensation by deactivating it. */
    2: bool active = true,

    /** Initial point position in the FCW plane of the projector. */
    3: Point2D position,

    /** The (measured) distance from the point to the projector may optionally be provided to improve the accuracy of
    the compensation. */
    4: optional double distance,

    /** Size of the search area in galvo increments. Maybe used if global search parameters are not sufficient. */
    5: optional i32 searchSize;
}

/** Data structure which comprises all the information needed for drift compensation.
An active drift compensation (dc) data set with set compensation matrix is used during the projection generation process
to reduce the negative effects of drift and ensure high geometric projection accuracy. */
struct DriftCompensation
{
    /** Unique identifier in GeoTree data structure */
    1: string name,

    /** Option to disable the drift compensation from being used for projection. There may be only a single active dc
    data set for a certain projector. */
    2: bool active = true,

    /** Serial number of the associated projector. */
    3: string projector,

    /** There have to be at least 4 active dc points for the drift compensation to work. For best results the dc
    points should be placed evenly around the entire projection area. */
    4: list<DriftCompensationPoint> points,

    /** Transformation matrix to compensate negative effects of drift.
    The matrix is initially unset. It is set by calling calculateDriftCompensation().
    Setting a dc data set with unset compensation matrix, resets an existing compensation. */
    5: optional Matrix4x4 compensation,

    /** In order to calculate the compensation matrix, the distance of all dc points to the projector has to be
    known. If the distances are not set by the user, they are estimated by assuming that all reference points lie
    approximately in one plane. This plane is defined with respect to the first active user coordinate system of the
    projector. The vector starts at the origin of the user coordinate system and is normal to the point plane.
    A vector of (0, 0, 100) means, that all reference points are located in a plane parallel to the x/y plane of the
    coordinate system at a z value (height) of 100. If no vector is given, the x/y plane is used. */
    6: optional Vector3D pointPlane,
}

/** Parameters for reflection point search. */
struct PointSearchParameters
{
    /** The detection hardware must reach the threshold in order for a point to be found. */
    1: optional i32 detectionThreshold;

    /** Size of the quadratic search area in galvo increments. */
    2: optional i32 searchSize;

    /** Distance in increments between scan lines. */
    3: optional i32 feedSize;

    /** Galvo step size in increments along a scan line. */
    4: optional i32 stepSize;

    /** Maximum number of retries in a single search attempt. */
    5: optional i32 maxTrials;

    /** Maximum number of retries with an increased search area. */
    6: optional i32 rescaleTrials;

    /** Percentage by which the search area is increased with every rescale trail (e.g. 20 = +20%). */
    7: optional i32 rescaleFactor;

    /** Maximum number of retries with a reduced detection threshold. */
    8: optional i32 reducedThresholdTrials;

    /** Percentage by which the detection threshold is reduced with every reduced threshold trial (e.g. 20 = -20%). */
    9: optional i32 reducedThresholdFactor;

    /** Inner region of the full search area where the found point has to be in order to be valid.
    A value of 80 [%] causes a repeated search centered at the detected position,
    if the point lies at the (20%) border of the search area. */
    10: optional i32 validationZoneFactor;

    /** Minimum number of successful search attempts. A value larger than 1 should be set, if the point search might be
    interfered by outer conditions. */
    11: optional i32 minNumFounds;

    /** Maximum number of search attempts. The value should be equal or larger than the minimum number of founds. */
    12: optional i32 maxNumSearches;

    /** The maximum allowed distance between multiple successful search attempts. If the found point positions are
    further appart than the given distance, no result is returned. */
    13: optional double maxDistBetweenFounds;
}

struct PointSearchResult
{
    /** The variable is true if the search is still running and false if it has finished. */
    1: bool stillSearching;

    /** Indicates if a point is found at the position given in startPointSearch(). */
    2: bool found;

    /** Position in the FCW plane of the found reflection point.
    If a point could not be found, the position is not set. */
    3: optional Point2D position;
}

struct Contact
{
    1: string name,
    2: string city,
    3: string country,
    4: string email,
}

/** Module which licenses a special feature, plugin or program. */
struct LicenseModule
{
    1: string name,

    /** End date of validation period ("1" means forever) */
    2: string validUntil,
}

/** Static information from the loaded license file. */
struct LicenseInfo
{
    /** Extract from the license holder's address in the license file. */
    1: Contact customer,

    /** Extract from the license grantor's address in the license file. */
    2: Contact grantor,

    /** List of modules which license special features, plugins or programs. */
    3: list<LicenseModule> modules,

    /** Projector id or system id */
    4: string validAt,

    /** End date of validation period ("1" means forever) */
    5: string validUntil,

    /** Name of the loaded license file. Empty if no license has been loaded. */
    6: string filename,
}

/** Information about different validity aspects of a license. */
struct LicenseValidity
{
    /** True if all other attributes are also true. */
    1: bool licenseValid = false,

    /** True if a license file has been loaded. */
    2: bool licenseLoaded = false,

    /** True if period of validity has not expired. */
    3: bool periodValid = false,

    /** True if license file has not been manipulated. */
    4: bool hashValid = false,

    /** True if license has been issued for one of the connected projectors or
    for the system the ZLP-Service runs on.*/
    5: bool systemValid = false,

    /** List of valid license modules. */
    6: list<string> validModules,
}

exception CantReadFile
{
    1: string fileName,
    2: string why,
}

exception CantWriteFile
{
    1: string fileName,
    2: string why
}

exception CantRenameCoordinatesystem
{
    /** coordinate system */
    1: string which,
    2: string why
}

/** Geotree elment does not exist */
exception ElementDoesNotExist
{
    /** element name */
    1: string which,

    /** parent name */
    2: string parent,

    /** child name */
    3: string child,
}

/** Geotree element is of wrong type */
exception ElementHasWrongType
{
    /** element name */
    1: string which,

    /** parent name */
    2: string parent,

    /** child name */
    3: string child,
}

/** An element path for Geotree is not in relative format */
exception InvalidRelativePath
{
    /** element name */
    1: string which,

    /** parent name */
    2: string parent,

    /** child name */
    3: string child,
}

/** An element can't be set as child */
exception CantSetChild
{
    1: string why,
    2: string parent,
    3: string child,
}

exception ElementAlreadyExists
{
    1: string why,
    2: string parent,
    3: string child,
}

exception InvalidTransformParam
{
    /** name of element */
    1: string which,
}

exception FunctionModuleClassNotRegistered
{
    /** name of class */
    1: string which,
}

exception FunctionModuleClassNotLicensed
{
    /** name of class */
    1: string which,
}

exception FunctionModulePropertyBranchAlreadyInUse
{
    1: string branchName,
    2: string usedByClass,
}

exception FunctionModuleIsAlreadyRunning
{
    /** name of function module instance */
    1: string fModUID,
}

exception FunctionModuleCantRunFromThisState
{
    /** name of function module instance */
    1: string fModUID,
}

/** Function module has run into a not recoverable error */
exception FunctionModuleRunFailedCritical
{
    /** name of function module instance */
    1: string fModUID,

    /** description of error */
    2: string description,
}

/** Function module has run into an recoverable error */
exception FunctionModuleRunFailedRecoverable
{
    /** name of function module instance */
    1: string fModUID,

    /** description of error */
    2: string description,
}

exception FunctionModuleCantDeleteModule
{
    /** name of instance and why */
    1: string whichAndWhy
}

exception PropertyNotFound
{
    1: string propName,
}

/** Stream/File of Properties can't be read correctly */
exception PropertyReadError
{
    1: string why,
}

/** A property change callback has thrown an exception */
exception PropertyChangeFailed
{
    /** name of property */
    1: string propName,

    /** name of command exception */
    2: string exceptionClass,

    /** detail of command exception */
    3: string exceptionDetail,
}

/** A property can't be set, because of limitations by type or options */
exception PropertySetError
{
    1: string propName,
    2: string exceptionDetail,
}

exception InvalidProjectionCoordinate
{
    1: string why,
    2: Point3D coordinate
    3: i32 lineIdx,
    4: string elementName,
    5: string projectorName,
    6: string coordSysName,
}

/** ZLP-Service cannot communicate with projector */
exception ErrorInProjectorCommunication
{
    1: string why,
}

exception PropertyNotRegisteredForAccessNotification
{
    1: string propName,
}

exception ClientNotRegisteredForPropertyAccessNotification
{
    1: string clientId,
    2: string propName,
}

exception FunctionModuleNotExistent
{
    1: string fModUID,
}

exception ClientNotRegisteredForFunctionModule
{
    1: string clientId,
    2: string fModUID,
}

exception RemoteControlInvalidParameters
{
    1: string whichAndWhy,
}

exception ProcessInCriticalErrorState
{
    1: string which,
    2: string description,
}

exception PythonError
{
    1: string errorMessage,
}

/** Locking failed for ZLP-Service while calling interface functionality */
exception ServiceLockTimeout
{
    1: string errorMessage,
}

/** Interface functions to communicate with the ZLP-Service */
service ServiceInterface
{
    void setRefSensorPGARef(1: string identification, 2: i16 pgared, 3: i16 refplus, 4: i16 pgagreen)
    void setRefSensorActiveDiodes(1: string identification, 2: i16 activeDiodes)
    i16 getRMSADCValue(1: string identification)

    ProjectorInfo_t getProjectorInfo(1: string identification)

    /** Opens the specified file and reads the configuration. */
    void ReadConfig
    (
        /** Name of the config file in the ZLP-Service's data directory. */
        1: string filename
    )
    throws (1: CantReadFile e1, 2: PropertyReadError e2, 3: ProcessInCriticalErrorState e3, 4: ServiceLockTimeout e4)

    /** Writes the configuration to the specified file. */
    void WriteConfig
    (
        /** Name of the config file in the ZLP-Service's data directory. */
        1: string filename
    )
    throws (1: CantWriteFile e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3)

    /** Reset ZLP-Service's configuration:
    Clears all GeoTree Data and closes all projector connections */
    void ResetConfig()
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2)

    /** Get list of all defined coordinate systems. */
    list<string> GetCoordinatesystemList()
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2)

    /** Rename a coordinate system. */
    void RenameCoordinatesystem(1: string oldname, 2: string newname)
    throws (1: CantRenameCoordinatesystem e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3)

    /** Get full list of names and types of all elements in the GeoTree. */
    list<GeoTreeElemId> GetGeoTreeIds
    (
        /** Name of branch, for which the elements are requested, "" or "/" for the whole tree */
        1: string branchName = "",

        /** Type of element to get ids for, ALL to get all element ids */
        2: GeoTreeElemTypes typeOfElement = GeoTreeElemTypes.ALL_TYPE
    )
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2, 3: InvalidRelativePath e3)

    /** Removes an existing GeoTree element and all of its children. */
    void RemoveGeoTreeElem
    (
        /** Name of the GeoTree element to remove. Use "" to remove all elements, even coordinate systems,
        separation planes, reference objects, etc. */
        1: string name = ""
    )
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: InvalidRelativePath e4)

    /** Check if a GeoTree element exists */
    bool GeoTreeElemExist(1: string name)
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2, 3: InvalidRelativePath e3)

    /** Rename a GeoTree element.
    Moves it inside the geotree. All missing path branches will be created of type GeoTreeGroup.
    If other group types are wished, one has to create them before renaming.
    */
    void RenameGeoTreeElem(1: string oldPath, 2: string newPath)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: InvalidRelativePath e4, 5: ElementHasWrongType e5)

    /** Get a GeoTree element.
    This function is useful to get access to the superclass of all element types.
    */
    GeoTreeElement GetGeoTreeElement(1: string name)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    /** Modify a existing GeoTree element.
    This function is useful to change properties of elements which are derived from GeoTreeElement.
    */
    void UpdateGeoTreeElement(1: GeoTreeElement el)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: InvalidRelativePath e4, 5: ElementHasWrongType e5)

    /** Get the base properties of a projection element specified by its path name.
    This function is useful to access only the base properties of projection elements regardless of their type.
    */
    ProjectionElement GetProjectionElement(1: string name)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    /** The attributes of an existing projection element will be overwritten.
    This function is useful to change the base properties of different types of projection elements in the same way.
    The standard use case is to first call GetProjectionElement("path/name") to get the current attribute values.
    Then change some properties except the element name and use UpdateProjectionElement() to upload them.
    */
    void UpdateProjectionElement(1: ProjectionElement projectionElement)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: InvalidRelativePath e4, 5: ElementHasWrongType e5)

    /** Get a 3D element specified by the name.
    This function is useful to get access to the superclass of projection elements.
    */
    Element3d GetElement3d(1: string name)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    /** Modify an existing 3d element. */
    void UpdateElement3d(1: Element3d el)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: InvalidRelativePath e4, 5: ElementHasWrongType e5)

    Polyline GetPolyLine
    (
        1: string name,

        /** Set this flag to true if you want to get no data, to reduce overhead */
        2: bool onlyAttributes = false
    )
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    /** Set or modify a polyline element. */
    void SetPolyLine(1: Polyline poly)
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2, 3: InvalidRelativePath e3,
            4: ElementHasWrongType e4)

    CircleSegment GetCircleSegment(1: string name)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    TextElement GetTextElement(1: string name)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    OvalSegment GetOvalSegment(1: string name)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    /** Get the points of a projection element. */
    list<list<Point3D>> GetLineList(1: string name)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: InvalidRelativePath e4)

    /** Create or modify a circle element. */
    void SetCircleSegment(1: CircleSegment circleSeg)
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2, 3: InvalidRelativePath e3,
            4: ElementHasWrongType e4)

    /** Set or modify a text element. */
    void SetTextElement(1: TextElement textElement)
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2, 3: InvalidRelativePath e3,
            4: ElementHasWrongType e4)

    /** Set or modify an oval segment element. */
    void SetOvalSegment(1: OvalSegment ovalSeg)
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2, 3: InvalidRelativePath e3,
            4: ElementHasWrongType e4)

    GeoTreeGroup GetGroup(1: string name)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    /** Set or modify a group element. */
    void SetGroup(1: GeoTreeGroup group)
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2, 3: InvalidRelativePath e3,
            4: ElementHasWrongType e4)

    Group3d GetGroup3d(1: string name)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    /** Set or modify a Group3d element. */
    void SetGroup3d(1: Group3d group)
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2, 3: InvalidRelativePath e3,
            4: ElementHasWrongType e4)

    ClipGroup GetClipGroup(1: string name)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    /** Set or modify a ClipGroup element. */
    void SetClipGroup(1:  ClipGroup group)
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2, 3: InvalidRelativePath e3,
            4: ElementHasWrongType e4)

    ClipRect GetClipRect(/** Name of the GroupElement */ 1: string name)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    /** Set or modify a ClipRect element. */
    void SetClipRect(1:  ClipRect rect)
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2, 3: InvalidRelativePath e3,
            4: ElementHasWrongType e4)

    Referenceobject GetReferenceobject(1: string name)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    /** Set or modify a Referenceobject element. */
    void SetReferenceobject(1: Referenceobject refObject)
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2, 3: InvalidRelativePath e3,
            4: ElementHasWrongType e4)

    /** Set the default voting parameters for requiring m out of n closely matched point search results
    before a point is accepted. The default for (m, n) is 1 of 3. The default matching theshold is 40 increments.
    */
    void setMajorityVoteParameters(1: i32 m, 2: i32 n, 3: double threshold)

    /** Creates polylines from a reference object to show reference point positions.
    For each reference point a cross is created. All cross polylines are put in a group named [referenceobjectname]_poly.
    Via parameter showTracePoints it can be chosen to create polylines for the trace points in FCW coordinate system or
    in referenced user coordinate system. Returns the name of the created polyline group.
    */
    string CreatePolylinesFromRefObject
    (
        /** name of the reference object */
        1: string name,

        /** shows trace point coordinates instead of reference point coordinates */
        2: bool showTracePoints
    )
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2, 3: InvalidRelativePath e3,
            4: ElementHasWrongType e4, 5: ElementDoesNotExist e5)

    ClipPlane GetClipPlane(1: string name)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    /** Set or modify a ClipPlane element. */
    void SetClipPlane(1: ClipPlane clipPlane)
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2, 3: InvalidRelativePath e3,
            4: ElementHasWrongType e4)

    /** Creates a function module of a certain type.
    The ZLP-Service can be extended via plugins by so called function modules. They all follow the same scheme in
    creating, destroying, running and parameter handling. The interface ensures that there exists only one instance
    of one class. If there exists an instance of a class type with the same branchName, FunctionModuleCreate() returns
    the name of the already existing function module. Clients which call this function successfully, will be
    registered to receive function module state change events.
    Returns unique name of the created function module, to have a identifier for the instance to use in the other
    module functions like Run/Stop.
    */
    string FunctionModuleCreate
    (
        /** Name of the function module type to create */
        1:string type,

        /** Branch name to put the modules properties in */
        2: string branchName,
    )
    throws (1: ProcessInCriticalErrorState e1, 2: FunctionModuleClassNotRegistered e2,
            3: FunctionModulePropertyBranchAlreadyInUse e3, 4: FunctionModuleClassNotLicensed e4,
            5: ServiceLockTimeout e5)

    /** Registers a client for access to a function module by UID.
    The UID is somehow transferred to the client. The UID can be used to control the function module.
    A client can unregister itself by calling FunctionModuleRelease().
    */
    void FunctionModuleRegisterClient(1:string fModUID)
    throws (1: ProcessInCriticalErrorState e1, 2: FunctionModuleNotExistent e2, 3: ServiceLockTimeout e3)

    /** Releases a created function module instance.
    If the client is the last accessor, the function module is deleted.
    */
    void FunctionModuleRelease
    (
        /** The name from the create call, to identify the function module instance */
        1:string functionModuleUID
    )
    throws (1: ProcessInCriticalErrorState e1, 2: FunctionModuleNotExistent e2,
            3: ClientNotRegisteredForFunctionModule e3, 4: FunctionModuleCantDeleteModule e4,
            5: ServiceLockTimeout e5)

    /** Call the run method of the function module.
    There are 2 kinds of function modules, one that performs some calculation in the Run call and returns true
    and the other starts some self running process and returns immediately with false. The second one keeps in
    RunningState after returning from the Run call (runs in the background). By asking for the state via
    FunctionModuleGetState(), one can find when the function module has finished.
    */
    bool FunctionModuleRun(1: string functionModuleUID)
    throws (1: FunctionModuleNotExistent e1, 2: ClientNotRegisteredForFunctionModule e2,
            3: FunctionModuleIsAlreadyRunning e3, 4: FunctionModuleCantRunFromThisState e4,
            5: FunctionModuleRunFailedCritical e5, 6: FunctionModuleRunFailedRecoverable e6,
            7: ErrorInProjectorCommunication e7, 8: ProcessInCriticalErrorState e8, 9: ServiceLockTimeout e9)

    /** Stops an in the background running function module.
    Returns true if the stop has performed immediately, false if one has to wait for state change to other than RUNNING
    */
    bool FunctionModuleStop(1: string functionModuleUID)
    throws (1: FunctionModuleNotExistent e1, 2: ClientNotRegisteredForFunctionModule e2,
            3: ProcessInCriticalErrorState e3, 4: ServiceLockTimeout e4)

    /** Set properties of a function module. */
    void FunctionModuleSetProperty(1: string functionModuleUID, 2: string propertyName, 3: string propertyValue)
    throws (1: PropertyNotFound e1, 2: FunctionModuleNotExistent e2, 3: ClientNotRegisteredForFunctionModule e3,
            4: ProcessInCriticalErrorState e4, 5: ServiceLockTimeout e5, 6: PropertyChangeFailed e6,
            7: PropertySetError e7)

    /** Get property values of function modules.
    Returns property value in a convertible string format.
    */
    string FunctionModuleGetProperty(1: string functionModuleUID, 2: string propertyName)
    throws (1: PropertyNotFound e1, 2: FunctionModuleNotExistent e2, 3: ClientNotRegisteredForFunctionModule e3,
            4: ProcessInCriticalErrorState e4, 5: ServiceLockTimeout e5)

    /** Get options of property of function modules.
    The following options can be retrieved (depending on type):
    - "type" valid Types are int, double, string, bool
    - "min", "max", "step" for ranges of numeric types
    - "default" the default value
    */
    string FunctionModuleGetPropertyOption(1: string functionModuleUID, 2: string propertyName, 3: string optionName)
    throws (1: PropertyNotFound e1, 2: FunctionModuleNotExistent e2, 3: ClientNotRegisteredForFunctionModule e3,
            4: ProcessInCriticalErrorState e4, 5: ServiceLockTimeout e5)

    /** Get a list of all created function modules for a client.
    This can be used to clear any previous created function modules. Returns strings of all running function modules.
    */
    list<string> FunctionModuleGetInstances()
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2)

    /** Getter which retrieves the remaining runtime of a function module.
    Returns the remaining runtime in seconds.
    */
    double FunctionModuleGetRemainingRunTime(1: string functionModuleUID)
    throws (1: FunctionModuleNotExistent e1, 2: ClientNotRegisteredForFunctionModule e2,
            3: ProcessInCriticalErrorState e3, 4: ServiceLockTimeout e4)

    /** Getter for a string if some exception occurred while running the module in the background.
    Returns string with the error description if some error occurs after Run else a string of length 0.
    */
    string FunctionModuleGetRunExceptionString(1: string functionModuleUID)
    throws (1: FunctionModuleNotExistent e1, 2: ClientNotRegisteredForFunctionModule e2,
            3: ProcessInCriticalErrorState e3, 4: ServiceLockTimeout e4)

    /** Getter for actual function module state. */
    FunctionModuleStates FunctionModuleGetState(1: string functionModuleUID)
    throws (1: FunctionModuleNotExistent e1, 2: ClientNotRegisteredForFunctionModule e2,
            3: ProcessInCriticalErrorState e3, 4: ServiceLockTimeout e4)

    /** Set the mode of a specific remote control.
    - Mode 0: the service mode is only accessible via the remote control itself and controls the projector directly.
    - Mode 1: projection mode
    - Mode 2: projector setup mode
    - Mode 3: info mode
    - Mode 4: clipping mode
    - Other modes can be defined by the user.
    */
    void RemoteControlSetMode
    (
        /** Address of remote control (1...64) */
        1: i16 addr,

        /** Mode to set for this remote control (1...16) */
        2: i16 mode,
    )
    throws (1: RemoteControlInvalidParameters e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3)

    /** Get the current mode of a specific remote control. */
    i16 RemoteControlGetMode(1: i16 addr)
    throws(1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2)

    /** Set a list of active remote control addresses.
    Only command from active remote controls are processed by ZLP-Service. By default all remote controls are active.
    */
    void RemoteControlSetActiveAddrs(1: list<i16> addrs)
    throws (1: RemoteControlInvalidParameters e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3)

    /** Get active remote control addresses. */
    list<i16> RemoteControlGetActiveAddrs()
    throws(1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2)

    /** Set the id of an assigned function module to a specific remote control.
    By doing so, one can control different function modules via different remote controls,
    which can run in the same mode.
    */
    void RemoteControlSetActiveFunctionModuleUID
    (
        /* address of remote control */
        1: i16 addr,

        /* UID of function module */
        2: string modUID
    )
    throws (1: RemoteControlInvalidParameters e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3)

    /** Get the UID of an assigned function module to a remote control. */
    string RemoteControlGetActiveFunctionModuleUID(1: i16 addr)
    throws (1: RemoteControlInvalidParameters e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3)

    /** Trigger a remote control command for testing and simulation. */
    void RemoteControlTriggerFrame
    (
        /** address of remote control */
        1: i16 adr,

        /** key command */
        2: RcCommandCodes cmd,

        /** toggle function active */
        3: bool toggle = false,

        /** Projector ID */
        4: i16 projector = 0,

        5: i32 timestamp = 0
    )
    throws (1: RemoteControlInvalidParameters e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3)

    /** Projectors are selected by remote control via an index from 1 to 16.
    With this function for each projector serial number an index can be set.
    */
    void RemoteControlSetProjectorIdxForSerial(1: i16 projectorIdx, 2: string projectorSerial = "")
    throws (1: RemoteControlInvalidParameters e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3)

    /** Simulate condition that a reflection elements detection changed. */
    void triggerReflectionStateChanged
    (
         /** Name of the element which should be triggered */
         1: string elementName,

         /** True if a reflection is detected, False otherwise */
         2: bool state,
    )
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2)

    /** Set the absolute increments at which the FPGA will move the projection in the image buffer.
    The velocity that is used during the projection must be set _before_ `updateProjection()` is called.
    */
    void setBufferVelocity(1: i32 dx, 2: i32 dy)
    throws (1:ServiceLockTimeout e1)

    /** Get a property value.
    Always use fully qualified name: e.g. Group1 or Group3/Group4.
    */
    string GetProperty(1: string name)
    throws (1: PropertyNotFound e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3)

    /** Set the value of an existing property. */
    void SetProperty(1: string name, 2: string value)
    throws (1: PropertyNotFound e1, 2: PropertyChangeFailed e2, 3: PropertySetError e3,
            4: ProcessInCriticalErrorState e4, 5: ServiceLockTimeout e5)

    /** Get a list of children of the current property.
    Returns a list of children names of the current property name, without "options".
    List is empty if no child exists.
    */
    list<string> GetPropChildren(1: string name)
    throws (1: PropertyNotFound e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3)

    /** Registers client to get signaled if a property value changes. */
    void RegisterForChangedProperty
    (
        /** name/path of property which changes should be signaled */
        1: string name
    )
    throws (1: PropertyNotFound e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3)

    /** Remove a registered client from getting value changed signals. */
    void UnRegisterForChangedProperty
    (
        /** name/path of property which changes should be signaled */
        1: string name
    )
    throws (1: PropertyNotFound e1, 2: PropertyNotRegisteredForAccessNotification e2,
            3: ClientNotRegisteredForPropertyAccessNotification e3, 4: ProcessInCriticalErrorState e4,
            5: ServiceLockTimeout e5)

    /** Project the current projection data.
    If a projector has nothing to project, it turns off its projection. */
    void updateProjection()
    throws (1: InvalidProjectionCoordinate e1, 2: ErrorInProjectorCommunication e2, 3: ProcessInCriticalErrorState e3,
            4: ServiceLockTimeout e4)

    /** Turn off all active projections immediately. */
    void stopProjection()

    /** Creates a channel from ZLP-Service to client for propagating events back to the client. */
    void ConnectClientEventChannel
    (
        /** Port at client to connect */
        1: i32 portAtClient
    )
    throws(1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2)

    /** Disconnect the event channel to the client. */
    void DisconnectClientEventChannel()
    throws(1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2)

    /** Write binary data to a file in the data directory of ZLP-Service.
    This function can be used for example to transfer a license file from a client application to ZLP-Service. */
    void writeFile(1: binary data, 2: string filename)

    /** Load a license file.
    If the file does not exist or if it is not a license file, an exception is thrown. Use writeFile() to transfer a
    local license file to a remote ZLP-Service. */
    void loadLicense
    (
        /** Absolute or relative path to a license file on the system where the ZLP-Service is running. A filename or
        relative path should be given with respect to the data directory of the ZLP-Service. */
        1: string filename
    )

    /** Check the validness of the current license.
    The function can check the license in general or a certain license module. A module is only valid if the license is
    also valid. */
    bool checkLicense
    (
        /** Leave empty to check the license in general or enter a name to check a specific license module. */
        1: string licenseModule
    )

    /** Get information about loaded license. */
    LicenseInfo getLicenseInfo()

    /** Get detailed information about the validity of the loaded license.
    This function can for example be used to learn more about the reasons why checkLicense() has returned false. */
    LicenseValidity getLicenseValidity()

    /** Set color map for pens */
    void SetPenColorMap
    (
        /** mapping of rgb color to pen number */
        1: map<i16,RGBValue> colorMap
    )
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2)

    /** Get mapping of rgb color to pen numbers. */
    map<i16, RGBValue> GetPenColorMap()
    throws (1: ProcessInCriticalErrorState e1, 2: ServiceLockTimeout e2)

    /** Get ZLP-Service's API version.
    The client's API version should be compatible (c.f. interface constants). */
    Version getApiVersion()

    /** Moves a projection element by an offset */
    void Translate(1: string name, 2: double dx, 3: double dy, 4: double dz)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    /** Rotates a projection element around its center or reference point. */
    void Rotate(1: string name, 2: double xRotationDegree, 3: double yRotationDegree, 4: double zRotationDegree)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    /** Rotates a projection element around the given point. */
    void RotateAroundReference(1: string name, 2: double xRotationDegree, 3: double yRotationDegree,
                               4: double zRotationDegree, 5: Point3D rotationCenter)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    /** Scales a projection element.
    Its center or reference point stays fixed. */
    void Scale(1: string name, 2: double scaleFactor)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5, 6:InvalidTransformParam e6)

    /** Scales a projection element with respect to a given fixed reference point. */
    void ScaleWithReference(1: string name, 2: double scaleFactor, 3: Point3D referencePoint)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5, 6:InvalidTransformParam e6)

    /** Reflects a projection element on the specified plane. */
    void Reflect(1: string name, 2: ReferencePlane reflectionPlane)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5, 6:InvalidTransformParam e6)

    /** Reflects a projection element on the specified plane at the given reference point. */
    void ReflectWithReference(1: string name, 2: ReferencePlane plane, 3: Point3D referencePoint)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5, 6:InvalidTransformParam e6)

    /** Resets the user transformation of a projection element. */
    void ResetTransformation(1: string name)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    /** Applies the user transformation of a projection element permanently.
    Superior group transformations are not taken into account. The user transformation is cleared afterwards.
    The function can not be applied to a group.
    */
    void ApplyTransformation(1: string name)
    throws (1: ElementDoesNotExist e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3,
            4: ElementHasWrongType e4, 5: InvalidRelativePath e5)

    /** Returns all signal collector parameters of reflection detection and remote control. */
    SignalCollectorParameters getSignalCollectorParameters()
    throws (1: PropertyNotFound e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3)

    void setSignalCollectorParameters(1: SignalCollectorParameters parameters)
    throws (1: PropertyNotFound e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3)

    void activateRemoteControl(1: bool activate)
    throws (1: PropertyNotFound e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3)

    void activateReflectionDetection(1: bool activate)
    throws (1: PropertyNotFound e1, 2: ProcessInCriticalErrorState e2, 3: ServiceLockTimeout e3)

    /** Get parameters controlling the management of projector connections */
    ProjectorConnectionParameters getProjectorConnectionParameters()

    /** Set parameters controlling the management of projector connections */
    void setProjectorConnectionParameters(1: ProjectorConnectionParameters parameters)

    /** Get general parameters controlling the projection generation process. */
    GlobalProjectionParameters getGlobalProjectionParameters()

    /** Return the factory default values for the global projection parameters. */
    GlobalProjectionParameters getGlobalProjectionDefaults()

    /** Set general parameters controlling the projection generation process. */
    void setGlobalProjectionParameters(1: GlobalProjectionParameters parameters)

    /** Get parameters controlling the projection generation process of a certain projector. */
    ProjectionParameters getProjectionParameters(1: string projector)

    /** Return the factory default values for the projector-specific projection parameters. */
    ProjectionParameters getProjectionDefaults(1: string projector)

    /** Set parameters controlling the projection generation process of a certain projector.
    If the projector id is an empty string, the parameters are used for all connected projectors.
    */
    void setProjectionParameters(1: ProjectionParameters parameters, 2: string projector)

    /** Project one or more point symbols in the FCW plane. */
    void projectMarkers
    (
        1: string projector,

        /** Positions of markers in the FCW plane. */
        2: list<Point2D> positions,

        /** Types of markers to project. If empty a horizontal cross is projected. */
        3: list<MarkerType> types,

        /** Sizes of markers in the FCW plane. If marker is of type "searchArea", the size is in galvo increments.
        If empty the default size of each type is used. */
        4: list<i32> sizes
    )

    /** Set new drift compensation data set or modify an existing one. */
    void setDriftCompensation(1: DriftCompensation data)

    /** Get existing drift compensation data set. */
    DriftCompensation getDriftCompensation
    (
        /** Name (path) of drift compensation data set */
        1: string name,
    )

    /** Calculate a drift compensation (dc)
    from all active dc points and their current positions. If no distance is provided for the dc points, a valid setup
    is needed for the associated projector in order for the calculation to work. */
    void calculateDriftCompensation
    (
        /** Name (path) of drift compensation data set */
        1: string name,

        /** Current position in the FCW plane of the dc points in the drift compensation data set. The number of
        positions has to match the number of active dc points. */
        2: list<Point2D> positions,
    )

    /** Set the global default parameters for point search. */
    void setPointSearchParameters(1: PointSearchParameters parameters)

    /** Get the global default parameters for point search. */
    PointSearchParameters getPointSearchParameters()

    /** Start a point search at the given position with the given projector. The search is done asynchronously and the
    function returns immediately. No other point search may be started for the same projector while the last one is
    still running. The point search result has to be polled with the function getPointSearchResult(). Starting a new
    point search clears the result of a previous search. */
    void startPointSearch
    (
        1: string projector,

        /** Position in the FCW plane where the search should be started. */
        2: Point2D position,

        /** Parameters for the point search. For every parameter which is not set, the default value is used
        (c.f. setPointSearchParameters()). */
        3: PointSearchParameters options
    )

    /** Returns the result of the last finished or currently running point search of the given projector.
    The function needs to be called repeatedly until the result indicates that the search has finished. */
    PointSearchResult getPointSearchResult(1: string projector)
}

/** Types of GeoTree change events */
enum GeoTreeChangeTypes
{
    NO_CHANGE,

    /** barker bit for changes at element element */
    EL_CHANGED_BIT = 0x10,

    /** attributes of an element changed (no data) */
    EL_ATTRIBUTES_CHANGED,

    /** data of an element changed, no attributes */
    EL_DATA_CHANGED,

    /** element created */
    EL_CREATED,

    /** element removed */
    EL_REMOVED,

    /** marker bit for changed colormap */
    COLORMAP_CHANGED = 0x20,

    /** marker bit for changed coordinate system */
    COORDSYS_CHANGED = 0x40,

    /** marker bit for whole tree changes */
    TREE_CHANGED_BIT = 0x80,

    /** on tree create */
    TREE_CREATED,

    /** on tree object removed */
    TREE_REMOVED,

    /** on restored tree */
    TREE_RESTORED,

    /** on cleared tree data */
    TREE_CLEARED,
}

/** Interface for the event back channel of ZLP-Service to a client. */
service ClientEventChannel
{
     /** Send path and value of property that has changed. */
    void PropertyChanged
    (
        /** full path of property that has changed */
        1: string name,

        /** value of property */
        2: string value
    )

     /** Send path and flag for element that was changed. */
    void GeoTreeChanged
    (
        /** integer value with flags of type GeoTreeChangedFlags */
        1: i32 changedFlags,

        /** identification of changed element */
        2: GeoTreeElemId element
    )

    /** Send remote control frame-received notification. */
    void RemoteControlFrameReceived
    (
        /** address of rc device */
        1: i16 adr,

        /** key command */
        2: RcCommandCodes cmd,

        /** toggle function active */
        3: bool toggle,

        /** Projector ID */
        4: i16 projector,

        5: i32 timestamp
    )

    /** Send changes of function module state. */
    void FunctionModuleStateChanged(1: string functionModuleUID, 2: FunctionModuleStates oldState,
                                    3: FunctionModuleStates newState)

    /** Triggered when reflection detection is enabled and the reflection state of an element changes. */
    void onReflectionStateChanged
    (
         /** name of the element that changed state */
         1: string elementName,

         /** true if a reflection is detected, false if not */
         2: bool state
    )
}
