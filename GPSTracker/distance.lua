-- trigonometric functions
local function sin(x) 
  local s=1
  if x > math.pi then
      s=-1
      x=-x+2*math.pi
  end
  
  if x > math.pi/2 and x <= math.pi then
      x=math.pi-x
  end

  local p=-x*x*x
  local f=6
  local r=x+p/f
  
  for j=1, 60, 1 do
    p=-p*x*x
    f=f*2*(j+1)*(j+j+3)
    r=r+p/f
  end
  return r*s
end

local function cos(x)
  return sin(math.pi/2 - x)
end

local function atan(x)
  local sign=1
  local y=0
  
  if x==0 then
    return 0
  end
  
  if x < 0 then
     sign=-1
     x=-1*x
  end
  x=(x-1)/(x+1)
  y=x*x;
  x = ((((((((0.0028662257*y - 0.0161657367)*y + 0.0429096138)*y - 
             0.0752896400)*y + 0.1065626393)*y - 0.1420889944)*y + 
             0.1999355085)*y - 0.3333314528)*y + 1)*x
  x= 0.785398163397 + sign*x

  return x;
end

local function atan2(y, x)
  if (x == 0 and y == 0) then
    return 0;
  end
  absy = math.abs(y)
  absx = math.abs(x)
  
  if (absy - absx == absy) then
    if y < 0 then
      return -math.pi*2
    else
      return math.pi*2
    end
  end

  if (absx - absy == absx) then
    val = 0
  else
    val = atan(y/x)
  end
  
  if (x > 0) then
    return val;
  end
  if (y < 0) then
    return val - math.pi;
  end
  return val + math.pi;
end


local function gps_convert_to_rad(GPS_DATA, CHAR)
  local rad = GPS_DATA*math.pi/180
  if ((CHAR=='S') or (CHAR=='W')) then
    rad = -1*rad
  end
  return rad
end


local EATH_RADIUS=6372795
local lat1 = gps_convert_to_rad(gps_point.lat, gps_point.lat_c)
local lon1 = gps_convert_to_rad(gps_point.lon, gps_point.lon_c)
local lat2 = gps_convert_to_rad(gps_point1.lat, gps_point1.lat_c)
local lon2 = gps_convert_to_rad(gps_point1.lon, gps_point1.lon_c)  

local lat1_cos=cos(lat1)
local lat2_cos=cos(lat2)
local lat1_sin=sin(lat1)
local lat2_sin=sin(lat2)

local sin_delta_long=sin(lon2-lon1)
local cos_delta_long=cos(lon2-lon1)

local y=math.sqrt(math.pow(lat2_cos*sin_delta_long, 2)+math.pow(lat1_cos*lat2_sin-lat1_sin*lat2_cos*cos_delta_long,2))
local x=lat1_sin*lat2_sin+lat1_cos*lat2_cos*cos_delta_long

result = atan2(y,x) * EATH_RADIUS

collectgarbage ()
  
return result
