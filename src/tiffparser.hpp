// ***************************************************************** -*- C++ -*-
/*
 * Copyright (C) 2006 Andreas Huggel <ahuggel@gmx.net>
 *
 * This program is part of the Exiv2 distribution.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, 5th Floor, Boston, MA 02110-1301 USA.
 */
/*!
  @file    tiffparser.hpp
  @brief   Class TiffParser to parse TIFF data.
  @version $Rev$
  @author  Andreas Huggel (ahu)
           <a href="mailto:ahuggel@gmx.net">ahuggel@gmx.net</a>
  @date    15-Mar-06, ahu: created
 */
#ifndef TIFFPARSER_HPP_
#define TIFFPARSER_HPP_

// *****************************************************************************
// included header files
#include "tiffcomposite.hpp"
#include "types.hpp"

// + standard includes
#include <iosfwd>
#include <cassert>

// *****************************************************************************
// namespace extensions
namespace Exiv2 {

// *****************************************************************************
// class declarations

    class Image;

// *****************************************************************************
// class definitions

    /*!
      @brief TIFF component factory for standard TIFF components.
     */
    class TiffCreator {
    public:
        /*!
          @brief Create the TiffComponent for TIFF entry \em extendedTag and
                 \em group based on the embedded lookup table.

          If a tag and group combination is not found in the table, a TiffEntry
          is created.  If the pointer that is returned is 0, then the TIFF entry
          should be ignored.
        */
        static TiffComponent::AutoPtr create(uint32_t extendedTag,
                                             uint16_t group);

    private:
        static const TiffStructure tiffStructure_[]; //<! TIFF structure
    }; // class TiffCreator

    /*!
      @brief Stateless parser class for data in TIFF format. Images use this
             class to decode and encode TIFF-based data. Uses class
             CreationPolicy for the creation of TIFF components.
     */
    class TiffParser {
    public:
        /*!
          @brief Decode TIFF metadata from a data buffer \em pData of length
                 \em size into \em pImage.

          This is the entry point to access image data in TIFF format. The
          parser uses classes TiffHeade2 and the TiffComponent and TiffVisitor
          hierarchies.

          @param pImage    Pointer to the image to hold the metadata
          @param pData     Pointer to the data buffer. Must point to data
                           in TIFF format; no checks are performed.
          @param size      Length of the data buffer.
          @param createFct Factory function to create new TIFF components.
        */
        static void decode(      Image*             pImage,
                           const byte*              pData,
                                 uint32_t           size,
                                 TiffCompFactoryFct createFct);
    }; // class TiffParser

}                                       // namespace Exiv2

#endif                                  // #ifndef TIFFPARSER_HPP_
